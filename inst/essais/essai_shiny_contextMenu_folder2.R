library(jsTreeR)
library(shiny)
library(jsonlite)

# TODO: edit file with aceEditor in a modal
# open file in RStudio
# search option
# icons for file language


js <- JS(
  "function (node) {",
  sprintf("  var sep = \"%s\";", .Platform$file.sep),
  "  var tree = $(\"#jstree\").jstree(true);",
  "  var items = {",
  "    Rename: {",
  "      separator_before: false,",
  "      separator_after: false,",
  "      label: \"Rename\",",
  "      action: function (obj) {",
  "        tree.edit(node);",
  "      }",
  "    },",
  "    Remove: {",
  "      separator_before: false,",
  "      separator_after: false,",
  "      label: \"Remove\",",
  "      action: function (obj) {",
  "        tree.delete_node(node);",
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
  "                if(children.indexOf(tree.get_text(node)) > -1) {",
  "                  tree.delete_node(node);",
  "                } else {",
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
  "  if(node.type === \"file\") {",
  "    return items;",
  "  } else {",
  "    return $.extend(item_create, items);",
  "  }",
  "}"
)

# make the nodes list from a vector of file paths
makeNodes <- function(leaves){
  dfs <- lapply(strsplit(leaves, "/"), function(s){
    item <-
      Reduce(function(a,b) paste0(a,"/",b), s[-1], s[1], accumulate = TRUE)
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
    label <- tail(strsplit(item, "/")[[1]], 1)
    if(length(children)){
      list(
        text = label,
        children = lapply(children, f),
        type = "folder"
      )
    }else{
      list(
        text = label,
        type = "file"
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
folderContents <- list.files(folder, recursive = TRUE)

nodes <- makeNodes(
  paste0(file.path(parent, folderContents))
)

types <- list(
  file = list(
    icon = "glyphicon glyphicon-file"
  )
)

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
      sort = TRUE
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

