library(jsTreeR)
library(shiny)
library(jsonlite)
library(rstudioapi)
library(shinyAce)

# TODO: edit file with aceEditor in a modal
# open file in RStudio
# search option
# icons for file language

icons <- list(
  jl = "supertinyicon-julia",
  js = "supertinyicon-javascript",
  jsx = "supertinyicon-react",
  py = "supertinyicon-python",
  scss = "supertinyicon-sass",
  json = "supertinyicon-json",
  java = "supertinyicon-java",
  rs = "supertinyicon-rust",
  ru = "supertinyicon-ruby",
  svg = "supertinyicon-svg"
)

js <- JS(
  "function (node) {",
  sprintf("  var icons = %s;", as.character(toJSON(icons, auto_unbox = TRUE))),
  "  var exts = Object.keys(icons);",
  sprintf("  var sep = \"%s\";", .Platform$file.sep),
  "  var tree = $(\"#jstree\").jstree(true);",
  "  var items = {",
  "    Rename: {",
  "      separator_before: false,",
  "      separator_after: false,",
  "      label: \"Rename\",",
  "      action: function (obj) {",
  "        tree.edit(node, null, function() {",
  "          var nodeType = tree.get_type(node);",
  "          if(nodeType === 'file' || exts.indexOf(nodeType) > -1) {",
  "            var nodeText = tree.get_text(node);",
  "            if(/\\./.test(nodeText)) {",
  "              var splittedText = nodeText.split('.');",
  "              var ext = splittedText[splittedText.length - 1].toLowerCase();",
  "              if(exts.indexOf(ext) > -1) {",
  "                tree.set_type(node, ext);",
  "              } else {",
  "                tree.set_type(node, 'file');",
  "              }",
  "            }",
  "          }",
  "        });",
  "      }",
  "    },",
  "    Remove: {",
  "      separator_before: false,",
  "      separator_after: false,",
  "      label: \"Remove\",",
  "      action: function (obj) {",
  "        Shiny.setInputValue('deleteNode', tree.get_path(node, sep));",
  "        tree.delete_node(node);",
  "      }",
  "    }",
  "  };",
  "  var items_file = {",
  "    Open: {",
  "      separator_before: false,",
  "      separator_after: false,",
  "      label: \"Open\",",
  "      action: function (obj) {",
  "        Shiny.setInputValue('openFile', tree.get_path(node, sep));",
  "      }",
  "    },",
  "    Edit: {",
  "      separator_before: false,",
  "      separator_after: false,",
  "      label: \"Edit\",",
  "      action: function (obj) {",
  "        Shiny.setInputValue('editFile', tree.get_path(node, sep), {priority: 'event'});",
  "      }",
  "    }",
  "  };",
  "  var item_create = {",
  "    Create: {",
  "      separator_before: false,",
  "      separator_after: false,",
  "      label: \"Create\",",
  "      action: false,",
  "      submenu: {",
  "        File: {",
  "          separator_before: false,",
  "          separator_after: false,",
  "          label: \"File\",",
  "          action: function (obj) {",
  "            var children = tree.get_node(node).children.map(",
  "              function(child) {return tree.get_text(child);}",
  "            );",
  "            node = tree.create_node(node, {type: \"file\"});",
  "            tree.edit(",
  "              node, null, function() {",
  "                var nodeText = tree.get_text(node);",
  "                if(children.indexOf(nodeText) > -1) {",
  "                  tree.delete_node(node);",
  "                } else {",
  "                  if(/\\./.test(nodeText)) {",
  "                    var splittedText = nodeText.split('.');",
  "                    var ext = splittedText[splittedText.length - 1].toLowerCase();",
  "                    if(exts.indexOf(ext) > -1) {",
  "                      tree.set_type(node, ext);",
  "                    }",
  "                  }",
  "                  Shiny.setInputValue(",
  "                    'createNode',",
  "                    {type: 'file', path: tree.get_path(node, sep)}",
  "                  );",
  "                }",
  "              }",
  "            );",
  "          }",
  "        },",
  "        Folder: {",
  "          separator_before: false,",
  "          separator_after: false,",
  "          label: \"Folder\",",
  "          action: function (obj) {",
  "            var children = tree.get_node(node).children.map(",
  "              function(child) {return tree.get_text(child);}",
  "            );",
  "            node = tree.create_node(node, {type: \"folder\"});",
  "            tree.edit(",
  "              node, null, function() {",
  "                if(children.indexOf(tree.get_text(node)) > -1) {",
  "                  tree.delete_node(node);",
  "                } else {",
  "                  Shiny.setInputValue(",
  "                    'createNode',",
  "                    {type: 'folder', path: tree.get_path(node, sep)}",
  "                  );",
  "                }",
  "              }",
  "            );",
  "          }",
  "        }",
  "      }",
  "    }",
  "  };",
  "  if(node.type === \"file\" || exts.indexOf(node.type) > -1) {",
  "    return $.extend(items, items_file);",
  "  } else {",
  "    return $.extend(item_create, items);",
  "  }",
  "}"
)

# make the nodes list from a vector of file paths
makeNodes <- function(files, dirs, icons){
  exts <- names(icons)
  sep <- .Platform$file.sep
  dfs <- lapply(strsplit(files, sep), function(s){
    item <-
      Reduce(function(a,b) paste0(a,sep,b), s[-1], s[1], accumulate = TRUE)
    data.frame(
      item = item,
      parent = c("root", item[-length(item)]),
      stringsAsFactors = FALSE
    )
  })
  dat <- dfs[[1]]
  for(i in 2:length(dfs)){
    dat <- merge(dat, dfs[[i]], all = TRUE)
  }
  f <- function(parent){
    i <- match(parent, dat$item)
    item <- dat$item[i]
    children <- dat$item[dat$parent==item]
    label <- tail(strsplit(item, sep)[[1]], 1)
    if(item %in% dirs){
      list(
        text = label,
        children = lapply(children, f),
        type = "folder"
      )
    }else{
      ext <- tolower(tools::file_ext(label))
      list(
        text = label,
        type = ifelse(ext %in% exts, ext, "file")
      )
    }
  }
  lapply(dat$item[dat$parent == "root"], f)
}

#folder <- system.file("www", "shared", package = "shiny")
folder <- normalizePath("~/Work/R/jsTreeR/inst/essais/shared/")
splittedPath <- strsplit(folder, .Platform$file.sep)[[1L]]
path <- paste0(head(splittedPath,-1L), collapse = .Platform$file.sep)
parent <- tail(splittedPath, 1L)
folders <- list.dirs(folder, full.names = FALSE)
folders_fullNames <- list.dirs(folder, full.names = TRUE)
emptyFolders <- folders[vapply(folders_fullNames, function(folder){
  length(list.files(folder, include.dirs = TRUE, recursive = TRUE)) == 0L
}, logical(1L))]
folderContents <- c(emptyFolders, list.files(folder, recursive = TRUE))

nodes <- makeNodes(
  file.path(parent, folderContents), c(parent,file.path(parent, folders[-1L])), icons
)


types <- append(list(
  file = list(
    icon = "glyphicon glyphicon-file"
  )
), setNames(lapply(names(icons), function(ext){
  list(icon = icons[[ext]])
}), names(icons)))


checkCallback <- JS(
  "function(operation, node, parent, position, more) {",
  "  if(operation === 'move_node') {",
  "    if(parent.type === 'file') {",
  "      return false;",
  "    }",
  "  }",
  "  return true;",
  "}"
)


ui <- fluidPage(

  tags$head(
    tags$style(
      HTML(c(
        ".red {color: red;}",
        ".green {color: green;}",
        ".jstree-proton {font-weight: bold;}",
        ".jstree-anchor {font-size: medium;}",
        "pre {font-weight: bold; line-height: 1;}"
      ))
    )
  ),

  titlePanel("Drag and drop the nodes"),

  fluidRow(
    column(
      width = 3,
      jstreeOutput("jstree")
    ),
    column(
      width = 4,
      tags$fieldset(
        tags$legend(tags$span(style = "color: blue;", "All nodes")),
        verbatimTextOutput("treeState")
      )
    ),
    column(
      width = 4,
      tags$fieldset(
        tags$legend(tags$span(style = "color: blue;", "Selected nodes")),
        verbatimTextOutput("treeSelected")
      )
    )
  )

)


server <- function(input, output){

  # observeEvent(input[["jstree_create"]], {
  #   print(input[["jstree_create"]])
  # })

  observeEvent(input[["editFile"]], {
    filePath <- file.path(path, input[["editFile"]])
    ext <- tolower(tools::file_ext(input[["editFile"]]))
    mode <- switch(ext,
      js = "javascript",
      jsx = "jsx",
      c = "c_cpp",
      cpp = "c_cpp",
      "c++" = "c_cpp",
      h = "c_cpp",
      hpp = "c_cpp",
      css = "css",
      gitignore = "gitignore",
      hs = "haskell",
      html = "html",
      java = "java",
      json = "json",
      jl = "julia",
      tex = "latex",
      md = "markdown",
      markdown = "markdown",
      rmd = "markdown",
      mysql = "mysql",
      ml = "ocaml",
      perl = "perl",
      pl = "perl",
      php = "php",
      py = "python",
      ru = "ruby",
      rs = "rust",
      scala = "scala",
      scss = "scss",
      sh = "sh",
      sql = "sql",
      svg = "svg",
      txt = "text",
      ts = "typescript",
      vb = "vbscript",
      xml = "xml",
      yaml = "yaml",
      yml = "yaml"
    )
    showModal(modalDialog(
      aceEditor(
        "aceEditor",
        value = paste0(suppressWarnings(readLines(filePath)), collapse = "\n"),
        mode = ifelse(is.null(mode), "plain_text", mode),
        theme = gsub(" ", "_", tolower(getThemeInfo()[["editor"]])),
        tabSize = 2,
        height = "60vh"
      ),
      footer = tags$div(
        actionButton(
          "editDone", "Done", class = "btn-success",
          onclick = sprintf("Shiny.setInputValue('filePath', '%s');", filePath)
        ),
        modalButton("Cancel")
      )
    ))
  })

  observeEvent(input[["editDone"]], {
    writeLines(input[["aceEditor"]], input[["filePath"]])
    removeModal()
  })

  observeEvent(input[["openFile"]], {
    navigateToFile(input[["openFile"]])
  })

  observeEvent(input[["deleteNode"]], {
    unlink(input[["deleteNode"]], recursive = TRUE)
  })

  observeEvent(input[["createNode"]], {
    nodePath <- file.path(path, input[["createNode"]][["path"]])
    if(input[["createNode"]][["type"]] == "file"){
      file.create(nodePath)
    }else{
      dir.create(nodePath)
    }
  })

  observeEvent(input[["jstree_rename"]], {
    from = file.path(
      path,
      paste0(input[["jstree_rename"]][["from"]], collapse = .Platform$file.sep)
    )
    to = file.path(
      path,
      paste0(input[["jstree_rename"]][["to"]], collapse = .Platform$file.sep)
    )
    if(file.exists(from) && from != to){
      file.rename(from, to)
    }
  })

  observeEvent(input[["jstree_move"]], {
    from = file.path(path, paste0(input[["jstree_move"]][["from"]], collapse = .Platform$file.sep))
    to = file.path(path, paste0(input[["jstree_move"]][["to"]], collapse = .Platform$file.sep))
    if(from != to){
      file.rename(from, to)
    }
  })

  output[["jstree"]] <- renderJstree({
    jstree(
      nodes,
      types = types,
      dragAndDrop = TRUE,
      checkboxes = FALSE,
      theme = "proton",
      contextMenu = list(select_node = FALSE, items = js),
      checkCallback = checkCallback,
      sort = TRUE,
      search = list(
        show_only_matches = TRUE,
        case_sensitive = FALSE,
        search_leaves_only = FALSE
      )
    )
  })

  output[["treeState"]] <- renderPrint({
    toJSON(input[["jstree"]], pretty = TRUE, auto_unbox = TRUE)
  })

  output[["treeSelected"]] <- renderPrint({
    toJSON(input[["jstree_selected"]], pretty = TRUE, auto_unbox = TRUE)
  })

}

shinyApp(ui, server)


