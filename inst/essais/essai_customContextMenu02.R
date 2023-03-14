library(jsTreeR)

nodes <- list(
  list(
    text = "Menu",
    state = list(opened = TRUE),
    children = list(
      list(
        text = "this node cannot be deleted",
        type = "undeletable"
      ),
      list(
        text = "B"
      ),
      list(
        text = "C"
      )
    )
  ),
  list(
    text = "Drag here:",
    state = list(opened = TRUE)
  )
)

customMenu <- JS(
  "function customMenu(node) {",
  "  var tree = $('#mytree').jstree(true);", # 'mytree' is the Shiny id or the elementId
  "  var items = {",
  "    'delete' : {",
  "      'label'  : 'Delete',",
  "      'action' : function (obj) { if(node.type !== 'undeletable') tree.delete_node(node); },",
  "      'icon'   : 'glyphicon glyphicon-trash'",
  "     }",
  "  }",
  "  return items;",
  "}")

jstree(
  nodes,
  types = list(undeletable = list()),
  checkCallback = TRUE,
  contextMenu = list(items = customMenu),
  elementId = "mytree" # don't use elementId in Shiny! use the Shiny id
)
