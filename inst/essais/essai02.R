library(jsTreeR)

nodes <- list(
  list(
    text = "RootA",
    type = "root",
    children = list(
      list(
        text = "ChildA1",
        type = "child"
      ),
      list(
        text = "ChildA2",
        type = "child"
      )
    )
  ),
  list(
    text = "RootB",
    type = "root",
    children = list(
      list(
        text = "ChildB1",
        type = "child"
      ),
      list(
        text = "ChildB2",
        type = "child"
      )
    )
  )
)

types <- list(
  root = list(
    icon = "glyphicon glyphicon-ok"
  ),
  child = list(
    icon = "glyphicon glyphicon-file"
  )
)

checkCallback <- JS(
  "function(operation, node, parent, position, more) {",
  "  if(operation === 'move_node') {",
  "    if(parent.id === '#' || parent.type === 'child') {",
  "      return false;", # prevent moving a child above or below the root
  "    }",               # and moving inside a child
  "  }",
  "  return true;", # allow everything else
  "}"
)

dnd <- list(
  is_draggable = JS(
    "function(node) {",
    "  return node[0].type === 'child';",
    "}"
  )
)

jstree(
  nodes,
  dragAndDrop = TRUE, dnd = dnd,
  types = types,
  checkCallback = checkCallback
)





