library(jsTreeR)

dat <- list(
  list(
    text = "RootA",
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
