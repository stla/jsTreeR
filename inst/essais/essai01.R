library(jsTreeR)

dat <- list(
  list(
    text = "RootA",
    data = list(value = 999),
    icon = "glyphicon glyphicon-folder-open",
    state = list(
      opened = TRUE,
      freezed = TRUE
    ),
    children = list(
      list(
        text = "ChildA1",
        icon = "glyphicon glyphicon-file",
        children = list(
          list(
            text = "XXX"
          )
        )
      ),
      list(
        text = "ChildA2",
        icon = "glyphicon glyphicon-file"
      )
    )
  ),
  list(
    text = "RootB",
    icon = "glyphicon glyphicon-folder-open",
    children = list(
      list(
        text = "ChildB1",
        icon = "glyphicon glyphicon-file"
      ),
      list(
        text = "ChildB2",
        icon = "glyphicon glyphicon-file"
      )
    )
  )
)

jstree(dat) %>%
  htmlwidgets::onRender(c(
    "function(el) {",
    "  $(el).on('close_node.jstree', function (e, data) {",
    "    if(data.node.state.freezed) {",
    "      setTimeout(function(){data.instance.open_node(data.node);}, 0);",
    "    }",
    "  });",
    "}"
  ))
