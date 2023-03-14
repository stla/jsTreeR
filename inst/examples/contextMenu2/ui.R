shinyUI(
  fluidPage(
    tags$head(
      tags$style(
        HTML(".green {color: green;}")
      )
    ),

    h3(
      "The first node has children and it is not possible ",
      "to delete it with the context menu."
    ),
    h3(
      "Nodes with type 'unalterable' cannot be altered with the context menu."
    ),

    jstreeOutput("mytree")
  )
)
