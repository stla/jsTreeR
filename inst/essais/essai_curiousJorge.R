library(jsTreeR)

nodes <- list(
  list(
    text = "Menu",
    state = list(opened = TRUE),
    children = list(
      list(
        text = "A",
        type = "moveable",
        state = list(disabled = TRUE)
      ),
      list(
        text = "B",
        type = "moveable",
        state = list(disabled = TRUE)
      ),
      list(
        text = "C",
        type = "moveable",
        state = list(disabled = TRUE)
      ),
      list(
        text = "D",
        type = "moveable",
        state = list(disabled = TRUE)
      )
    )
  ),
  list(
    text = "Drag here:",
    type = "target",
    state = list(opened = TRUE)
  )
)

checkCallback <- JS(
  "function(operation, node, parent, position, more) { console.log(node);",
  "  if(operation === 'copy_node') {",
  "    if(parent.id === '#' || node.parent !== 'j1_1' || parent.type !== 'target') {",
  "      return false;", # prevent moving an item above or below the root
  "    }",               # and moving inside an item except a 'target' item
  "  }",
  "  return true;",      # allow everything else
  "}"
)

dnd <- list(
  always_copy = TRUE,
  is_draggable = JS(
    "function(node) {",
    "  return node[0].type === 'moveable';",
    "}"
  )
)

customMenu <- JS(
  "function customMenu(node) {",
  "  var tree = $('#mytree').jstree(true);", # 'mytree' is the Shiny id or the elementId
  "  var items = {",
  "    'delete' : {",
  "      'label'  : 'Delete',",
  "      'action' : function (obj) { tree.delete_node(node); },",
  "      'icon'   : 'glyphicon glyphicon-trash'",
  "     }",
  "  }",
  "  return items;",
  "}")


jstree(
  nodes, dragAndDrop = TRUE, dnd = dnd, checkCallback = checkCallback,
  types = list(moveable = list(), target = list()),
  contextMenu = list(items = customMenu),
  elementId = "mytree" # don't use elementId in Shiny! use the Shiny id
)
