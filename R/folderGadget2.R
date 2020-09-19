#' Folder gadget
#' @description Shiny gadget allowing to manipulate a folder.
#'
#' @param dir path to a folder
#'
#' @import shiny miniUI
#' @importFrom rstudioapi getThemeInfo navigateToFile
#' @importFrom tools file_ext
#' @importFrom shinyAce aceEditor
#' @importFrom stats setNames
#' @export
folderGadget2 <- function(dirs, tabs = FALSE) {

  #TODO: handle 'Cut' DONE
  # options for tabs DONE
  # aceEditor for jstree2:
  # prevent moving at root

  # if(!dir.exists(dir)){
  #   stop(sprintf('"%s" is not a directory.', dir))
  # }

  if(!is.element("jsTreeR", .packages())){
    attachNamespace("jsTreeR")
  }

  icons <- list(
    jl = "supertinyicon-julia",
    js = "supertinyicon-javascript",
    jsx = "supertinyicon-react",
    py = "supertinyicon-python",
    scss = "supertinyicon-sass",
    json = "supertinyicon-json",
    java = "supertinyicon-java",
    md = "supertinyicon-markdown",
    markdown = "supertinyicon-markdown",
    rmd = "supertinyicon-markdown",
    rs = "supertinyicon-rust",
    ru = "supertinyicon-ruby",
    svg = "supertinyicon-svg",
    c = "othericon-c",
    cpp = "othericon-cpp",
    "c++" = "othericon-cpp",
    h = "othericon-c",
    hpp = "othericon-cpp",
    css = "othericon-css",
    hs = "othericon-haskell",
    html = "othericon-html",
    rhtml = "othericon-html",
    r = "othericon-r",
    yaml = "othericon-yaml"
  )

  js <- function(treeId){
    JS(
      "function(node) {",
      sprintf("  var tree = $(\"#%s\").jstree(true);", treeId),
      "  if(node.type === \"file\" || exts.indexOf(node.type) > -1) {",
      "    return $.extend(Items(tree, node, false), items_file(tree, node));",
      "  } else {",
      "    return $.extend(item_create(tree, node), Items(tree, node, true));",
      "  }",
      "}"
    )
  }

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
        ext <- tolower(file_ext(label))
        list(
          text = label,
          type = ifelse(ext %in% exts, ext, "file")
        )
      }
    }
    lapply(dat$item[dat$parent == "root"], f)
  }

  paths <- setNames(character(2L), c("jstree", "jstree2"))
  parents <- character(2L)

  folder <- normalizePath(dirs[1], winslash = "/")
  splittedPath <- strsplit(folder, .Platform$file.sep)[[1L]]
  path <- paths[1L] <- paste0(head(splittedPath,-1L), collapse = .Platform$file.sep)
  parent <- parents[1L] <- tail(splittedPath, 1L)
  folders <- list.dirs(folder, full.names = FALSE)
  folders_fullNames <- list.dirs(folder, full.names = TRUE)
  emptyFolders <- folders[vapply(folders_fullNames, function(folder){
    length(list.files(folder, include.dirs = TRUE, recursive = FALSE)) == 0L
  }, logical(1L))]
  folderContents <- c(emptyFolders, list.files(folder, recursive = TRUE))
  nodes <- makeNodes(
    file.path(parent, folderContents), c(parent,file.path(parent, folders[-1L])), icons
  )

  folder <- normalizePath(dirs[2], winslash = "/")
  splittedPath <- strsplit(folder, .Platform$file.sep)[[1L]]
  path <- paths[2L] <- paste0(head(splittedPath,-1L), collapse = .Platform$file.sep)
  parent <- parents[2L] <- tail(splittedPath, 1L)
  folders <- list.dirs(folder, full.names = FALSE)
  folders_fullNames <- list.dirs(folder, full.names = TRUE)
  emptyFolders <- folders[vapply(folders_fullNames, function(folder){
    length(list.files(folder, include.dirs = TRUE, recursive = FALSE)) == 0L
  }, logical(1L))]
  folderContents <- c(emptyFolders, list.files(folder, recursive = TRUE))
  nodes2 <- makeNodes(
    file.path(parent, folderContents), c(parent,file.path(parent, folders[-1L])), icons
  )

  if(parents[1L] == parents[2L]){
    parents[1L] <- paste0(parents[1L], " (1)")
    parents[2L] <- paste0(parents[2L], " (2)")
  }

  types <- append(list(
    file = list(
      icon = "glyphicon glyphicon-file"
    ),
    folder = list()
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

  themeInfo <- getThemeInfo()

  ui <- miniPage(

    tags$head(
      tags$style(
        HTML(
          c(
            ".jstree-proton {font-weight: bold;}",
            ".jstree-anchor {font-size: medium;}",
            "#jstree-search,#jstree2-search {background-color: seashell;}",
            "#shiny-modal .modal-dialog div[class^='modal-'] {",
            "  background-color: maroon;",
            "}",
            ".gadget-block-button {background-color: transparent;}",
            ".ace_scrollbar::-webkit-scrollbar-track {",
            "  border-radius: 10px;",
            "  background-color: crimson;",
            "}",
            ".ace_scrollbar::-webkit-scrollbar {",
            "  background-color: transparent;",
            "}",
            ".ace_scrollbar::-webkit-scrollbar-thumb {",
            "  border-radius: 10px;",
            "  background-color: tomato;",
            "}"
          )
        )
      ),
      tags$script(
        HTML(
          "var copiedNode = null;",
          sprintf("var exts = [%s];", toString(paste0("'", names(icons), "'"))),
          sprintf("var sep = \"%s\";", .Platform$file.sep),
          "function Items(tree, node, paste) {",
          "  return {",
          "    Copy: {",
          "      separator_before: true,",
          "      separator_after: false,",
          "      label: \"Copy\",",
          "      action: function (obj) {",
          "        tree.copy(node);",
          "        copiedNode = {node: node, operation: 'copy'};", # use get_buffer and clear_buffer instead ?
          "      }",
          "    },",
          "    Cut: {",
          "      separator_before: false,",
          "      separator_after: !paste,",
          "      label: \"Cut\",",
          "      action: function (obj) {",
          "        tree.cut(node);",
          "        copiedNode = {instance: tree, node: node, operation: 'cut'};",
          "      }",
          "    },",
          "    Paste: paste ? {",
          "      separator_before: false,",
          "      separator_after: true,",
          "      label: \"Paste\",",
          "      _disabled: copiedNode === null,",
          "      action: function (obj) {",
          "        var children = tree.get_node(node).children.map(",
          "          function(child) {return tree.get_text(child);}",
          "        );",
          "        if(children.indexOf(copiedNode.node.text) === -1) {",
          #"          tree.paste(node);",
          "          var operation = copiedNode.operation;",
          "          tree.copy_node(copiedNode.node, node, 0, function() {",
          "            Shiny.setInputValue('operation', operation);",
          "          });",
          "          if(operation === 'cut') {",
          "            copiedNode.instance.delete_node(copiedNode.node);",
          "          }",
          "          copiedNode = null;",
          "        }",
          "      }",
          "    } : null,",
          "    Rename: {",
          "      separator_before: true,",
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
          "      separator_after: true,",
          "      label: \"Remove\",",
          "      action: function (obj) {",
          "        Shiny.setInputValue('deleteNode', tree.get_path(node, sep));",
          "        tree.delete_node(node);",
          "      }",
          "    }",
          "  };",
          "}",
          "function items_file(tree,node) {",
          "  return {",
          "    Open: {",
          "      separator_before: true,",
          "      separator_after: false,",
          "      label: \"Open\",",
          "      title: 'Open in RStudio',",
          "      action: function (obj) {",
          "        Shiny.setInputValue('openFile', tree.get_path(node, sep));",
          "      }",
          "    },",
          "    Edit: {",
          "      separator_before: false,",
          "      separator_after: true,",
          "      label: \"Edit\",",
          "      action: function (obj) {",
          "        Shiny.setInputValue('editFile', tree.get_path(node, sep), {priority: 'event'});",
          "      }",
          "    }",
          "  };",
          "}",
          "function item_create(tree,node) {",
          "  return {",
          "    Create: {",
          "      separator_before: true,",
          "      separator_after: true,",
          "      label: \"Create\",",
          "      action: false,",
          "      submenu: {",
          "        File: {",
          "          separator_before: true,",
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
          "          separator_after: true,",
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
          "}"
        )
      )
    ),

    if(tabs){
      miniTabstripPanel(
        miniTabPanel(
          parents[1L],
          miniContentPanel(
            jstreeOutput("jstree")
          )
        ),
        miniTabPanel(
          parents[2L],
          miniContentPanel(
            jstreeOutput("jstree2")
          )
        ),
        between = miniButtonBlock(
          actionButton("done", "Done", class = "btn-primary"),
          border = NULL
        )
      )
    }else{
      miniContentPanel(
        miniButtonBlock(
          actionButton("done", "Done", class = "btn-primary"),
          border = NULL
        ),
        fillRow(
          jstreeOutput("jstree", width = "50%"),
          jstreeOutput("jstree2", width = "50%")
        )
      )
    }

  )

  server <- function(input, output){

    observeEvent(input[["done"]], {
      stopApp()
    })

    observeEvent(input[["editFile"]], {
      filePath <- file.path(paths[input[["jsTreeInstance"]]], input[["editFile"]])
      ext <- tolower(file_ext(input[["editFile"]]))
      mode <- switch(ext,
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
                     js = "javascript",
                     jsx = "jsx",
                     json = "json",
                     jl = "julia",
                     tex = "latex",
                     md = "markdown",
                     map = "json",
                     markdown = "markdown",
                     rmd = "markdown",
                     mysql = "mysql",
                     ml = "ocaml",
                     perl = "perl",
                     pl = "perl",
                     php = "php",
                     py = "python",
                     r = "r",
                     rhtml = "rhtml",
                     rnw = "latex",
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
          theme = gsub(" ", "_", tolower(themeInfo[["editor"]])),
          tabSize = 2,
          height = "60vh"
        ),
        footer = tags$div(
          actionButton(
            "editDone", "Done", class = "btn-success",
            onclick = sprintf("Shiny.setInputValue('filePath', '%s');", filePath)
          ),
          modalButton("Cancel")
        ),
        size = "l"
      ))
    })

    observeEvent(input[["editDone"]], {
      writeLines(input[["aceEditor"]], input[["filePath"]])
      removeModal()
    })

    observeEvent(input[["openFile"]], {
      if(file.exists(input[["openFile"]])){
        navigateToFile(input[["openFile"]])
      }
    })

    observeEvent(input[["deleteNode"]], {
      unlink(input[["deleteNode"]], recursive = TRUE)
    })

    observeEvent(input[["createNode"]], {
      nodePath <- file.path(paths[input[["jsTreeInstance"]]], input[["createNode"]][["path"]])
      if(input[["createNode"]][["type"]] == "file"){
        file.create(nodePath)
      }else{
        dir.create(nodePath)
      }
    })

    observeEvent(input[["jstree_rename"]], {
      from = file.path(
        paths[input[["jsTreeInstance"]]],
        paste0(input[["jstree_rename"]][["from"]], collapse = .Platform$file.sep)
      )
      to = file.path(
        paths[input[["jsTreeInstance"]]],
        paste0(input[["jstree_rename"]][["to"]], collapse = .Platform$file.sep)
      )
      if(file.exists(from) && from != to){
        file.rename(from, to)
      }
    })

    observeEvent(input[["jsTreeCopied"]], {
      copied <- input[["jsTreeCopied"]]
      print("copied:")
      print(copied)
      print("operation:")
      print(input[["operation"]])
      from = file.path(
        paths[copied[["from"]][["instance"]]],
        paste0(copied[["from"]][["path"]], collapse = .Platform$file.sep)
      )
      to = file.path(
        paths[copied[["to"]][["instance"]]],
        paste0(copied[["to"]][["path"]], collapse = .Platform$file.sep)
      )
      if(from != to){
        if(input[["operation"]] == "copy"){
          file.copy(from, to)
        }else{
          file.rename(from, to)
        }
      }
    })

    observeEvent(input[["jsTreeMoved"]], { # never triggered!
      moved <- input[["jsTreeMoved"]]
      print("moved:")
      print(moved)
      from = file.path(
        paths[moved[["from"]][["instance"]]],
        paste0(moved[["from"]][["path"]], collapse = .Platform$file.sep)
      )
      to = file.path(
        paths[moved[["to"]][["instance"]]],
        paste0(moved[["to"]][["path"]], collapse = .Platform$file.sep)
      )
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
        contextMenu = list(select_node = FALSE, items = js("jstree")),
        checkCallback = checkCallback,
        sort = TRUE,
        search = list(
          show_only_matches = TRUE,
          case_sensitive = FALSE,
          search_leaves_only = FALSE
        )
      )
    })

    output[["jstree2"]] <- renderJstree({
      jstree(
        nodes2,
        types = types,
        dragAndDrop = TRUE,
        checkboxes = FALSE,
        theme = "proton",
        contextMenu = list(select_node = FALSE, items = js("jstree2")),
        checkCallback = checkCallback,
        sort = TRUE,
        search = list(
          show_only_matches = TRUE,
          case_sensitive = FALSE,
          search_leaves_only = FALSE
        )
      )
    })

  }

  runGadget(shinyApp(ui, server))

}
