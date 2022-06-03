shinyUI(fluidPage(
  h1("Right-click on a file to view it."),
  fluidRow(
    column(
      width = 12, treeNavigatorUI("explorer")
    )
  )
))
