library(jsTreeR)
library(shiny)
library(jsonlite)

nodes <- list(
  list(
    text = "RootA",
    icon = "far fa-moon red",
    children = list(
      list(
        text = "ChildA1",
        icon = "fa fa-leaf green",
        data = list(value = "A1")
      ),
      list(
        text = "ChildA2",
        icon = "fa fa-leaf green",
        data = list(value = "A2")
      )
    )
  ),
  list(
    text = "RootB",
    icon = "far fa-moon red",
    children = list(
      list(
        text = "ChildB1",
        icon = "fa fa-leaf green",
        data = list(value = "B1")
      ),
      list(
        text = "ChildB2",
        icon = "fa fa-leaf green",
        data = list(value = "B2")
      )
    )
  )
)
