library(jsTreeR)

dat <- list(
  list(
    text = "RootA",
    data = list(value = 999),
    icon = "glyphicon glyphicon-folder-open",
    a_attr = list(title = "TITLE", style = "color: red;"),
    li_attr = list(title = "XXX", style = "line-height: 5; background-color: pink;"),
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

jstree(dat, dragAndDrop = TRUE)
