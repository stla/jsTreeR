library(jsTreeR)

dat <- list(
  list(
    text = "RootA",
    data = list(value = 999),
    icon = "glyphicon glyphicon-flash",
    children = list(
      list(text = "ChildA1"),
      list(text = "ChildA2")
    )
  ),
  list(
    text = "RootB",
    children = list(
      list(text = "ChildB1"),
      list(text = "ChildB2")
    )
  )
)

jstree(dat, dragAndDrop = TRUE)
