library(jsTreeR)

dat <- list(
  list(
    text = "RootA",
    data = list(value = 999),
    icon = "glyphicon glyphicon-folder-open",
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

jstree(dat, dragAndDrop = TRUE, search = TRUE)
