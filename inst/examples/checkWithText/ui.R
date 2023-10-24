shinyUI(
  fluidPage(
    tags$h3("The `checkWithText` option."),
    br(),
    splitLayout(
      tagList(
        tags$h4("`checkWithText` is `TRUE` (default)"),
        helpText("You can click on a node text to select this node.")
      ),
      tagList(
        tags$h4("`checkWithText` is `FALSE`"),
        helpText("Try to click on a node text.")
      )
    ),
    splitLayout(
      jstreeOutput("tree1"), jstreeOutput("tree2")
    )
  )
)
