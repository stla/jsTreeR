library(jsTreeR)

checkCallback <- JS(
  "function(operation, node, parent, position, more) {",
  "  if(more) {",
  "    if(more.is_multi) {",
  "      more.origin.settings.dnd.always_copy = true;",
  "    } else {",
  "      more.origin.settings.dnd.always_copy = false;",
  "    }",
  "  }",
  "  return true;",
  "}"
)

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

jstree(
  nodes,
  dragAndDrop = TRUE,
  types = types,
  checkCallback = checkCallback
)
