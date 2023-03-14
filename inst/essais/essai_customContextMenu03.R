library(jsTreeR)
library(shiny)

nodes <- list(
  list(
    text  = "Branch 1",
    state = list(opened = TRUE),
    type  = "parent",
    children = list(
      list(text = "Leaf A", icon = "fa-solid fa-leaf green"),
      list(text = "Leaf B", type = "unalterable"),
      list(text = "Leaf C", type = "unalterable"),
      list(text = "Leaf D", type = "unalterable")
    )
  ),
  list(
    text  = "Branch 2",
    type  = "parent"
  )
)

customMenu <- JS("function customMenu(node)
{
  var tree = $('#mytree').jstree(true);
  var items = {
    'rename' : {
      'label' : 'Rename',
      'action' : function (obj) { tree.edit(node); },
      'icon': 'glyphicon glyphicon-edit'
    },
    'delete' : {
      'label' : 'Delete',
      'action' : function (obj) { tree.delete_node(node); },
      'icon' : 'glyphicon glyphicon-trash'
    },
    'create' : {
      'label' : 'Create',
      'action' : function (obj) { tree.create_node(node); },
      'icon': 'glyphicon glyphicon-plus'
    }
  }

  // prevent deletion of nodes which have children
  if(node.children.length > 0) {
    items.delete._disabled = true;
  }

  // disable the context menu for 'unalterable' nodes
  if(node.type === 'unalterable') {
    items.rename._disabled = true;
    items.delete._disabled = true;
    items.create._disabled = true;
  }

  return items;
}")


ui <- fluidPage(
  tags$head(
    tags$style(
      HTML(".green {color: green;}")
    )
  ),
  h3(
    "The first node has children and it is not possible ",
    "to delete it with the context menu."
  ),
  h3(
    "Nodes with type 'unalterable' cannot be altered with the context menu."
  ),
  jstreeOutput("mytree")
)

server <- function(input, output, session){
  output[["mytree"]] <- renderJstree({
    jstree(
      nodes,
      checkCallback = TRUE,
      contextMenu = list(items = customMenu),
      types = list(
        "unalterable" = list(icon = "fa-solid fa-leaf"),
        "parent"      = list(icon = "fa-brands fa-pagelines")
      ),
      theme = "proton"
    )
  })
}

shinyApp(ui, server)
