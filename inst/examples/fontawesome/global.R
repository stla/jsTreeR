# drag-and-drop, checkboxes, proton theme, fontawesome icons ####

library(jsTreeR)
library(shiny)
library(jsonlite)

nodes <- list(
  list(
    text = "RootA",
    data = list(value = 999),
    icon = "far fa-moon red",
    children = list(
      list(
        text = "ChildA1",
        icon = "fa fa-leaf green"
      ),
      list(
        text = "ChildA2",
        icon = "fa fa-leaf green"
      )
    )
  ),
  list(
    text = "RootB",
    icon = "far fa-moon red",
    children = list(
      list(
        text = "ChildB1",
        icon = "fa fa-leaf green"
      ),
      list(
        text = "ChildB2",
        icon = "fa fa-leaf green"
      )
    )
  )
)
