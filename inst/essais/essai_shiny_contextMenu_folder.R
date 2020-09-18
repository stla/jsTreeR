library(jsTreeR)
library(shiny)
library(jsonlite)

# TODO: edit file with aceEditor in a modal
# open file in RStudio
# search option
# icons for file language

replaceNodeValue <- HTML(
  "function replaceChildValue(child, regexp, newValue) {",
  "  child.data.value = child.data.value.replace(regexp, newValue);",
  "  child.children.forEach(function(child){replaceChildValue(child, regexp, newValue);});",
  "}",
  "function replaceNodeValue(node) {",
  sprintf("  var sep = \"%s\";", .Platform$file.sep),
  "  var value = node.data.value;",
  "  var splittedValue = value.split(sep);",
  "  splittedValue[splittedValue.length - 1] = node.text;",
  "  var newValue = splittedValue.join(sep);",
  "  node.data.value = newValue;",
  "  var regexp = new RegExp(\"^\" + value);",
  "console.log('node',node);",
  "  node.children.forEach(function(child){replaceChildValue(child, regexp, newValue);});",
  "}"
)

js <- JS(
  "function (node) {",
  sprintf("  var sep = \"%s\";", .Platform$file.sep),
  "  var tree = $(\"#jstree\").jstree(true);",
  "console.log('tree',tree);",
  "  var items = {",
  "    Rename: {",
  "      separator_before: false,",
  "      separator_after: false,",
  "      label: \"Rename\",",
  "      action: function (obj) {",
  "console.log('obj',obj);console.log('node',node);",
  "        var from = tree.get_path(node, sep);",
  "        var to;",
  "        tree.edit(node, null, function(){to = tree.get_path(node, sep); Shiny.setInputValue('rename', {from: from, to: to});});",
#  "        tree.edit(node, null, function(){replaceNodeValue(tree.get_json(node));});",
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
  "            node = tree.create_node(node, {type: \"file\"});",
  "            tree.edit(node);",
  "          }",
  "        },",
  "        Folder: {",
  "          separator_before: false,",
  "          separator_after: false,",
  "          label: \"Folder\",",
  "          action: function (obj) {",
  "            node = tree.create_node(node, {children: true, type: \"folder\"});",
  "            tree.edit(node);",
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
makeNodes <- function(leaves, path){
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
        data = list(value = paste0(path,item)),
        children = lapply(children, f),
        type = "folder"
      )
    }else{
      list(
        text = label,
        data = list(value = paste0(path,item)),
        type = "file"
      )
    }
  }
  lapply(dat$item[dat$parent == "root"], f)
}

folder <- system.file("www", "shared", package = "shiny")
splittedPath <- strsplit(folder, .Platform$file.sep)[[1L]]
path <- paste0(head(splittedPath,-1L), collapse = .Platform$file.sep)
parent <- tail(splittedPath, 1L)
folderContents <- list.files(folder, recursive = TRUE)

nodes <- makeNodes(
  paste0(file.path(parent, folderContents)),
  paste0(path, .Platform$file.sep)
)

types <- list(
  file = list(
    icon = "glyphicon glyphicon-file"
  )
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
    ),
    tags$script(replaceNodeValue)
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

  observe(print(input[["rename"]]))

  observe(print(input[["jstree_move"]]))

  output[["jstree"]] <- renderJstree({
    jstree(
      nodes,
      types = types,
      dragAndDrop = TRUE,
      checkboxes = TRUE,
      theme = "proton",
      contextMenu = list(select_node = FALSE, items = js)
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


