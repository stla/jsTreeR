shinyUI(
  fluidPage(
    tags$head(
      tags$style(HTML(css))
    ),

    tags$h2("The `checkWithText` option. Drag-and-drop is enabled."),
    tags$hr(),

    splitLayout(
      tagList(
        tags$h3("`checkWithText` is `TRUE` (default)"),
        helpText("Here you can click on a node text to select this node.")
      ),
      tagList(
        tags$h3("`checkWithText` is `FALSE`"),
        helpText("Here you can't. Use 'CTRL' to select multiple nodes.")
      )
    ),
    splitLayout(
      jstreeOutput("tree1"), jstreeOutput("tree2")
    ),

    splitLayout(

      splitLayout(
        tagList(
          tags$h4("Checked:"), verbatimTextOutput("checked1")
        ),
        tagList(
          tags$h4("Selected:"), verbatimTextOutput("selected1")
        )
      ),

      splitLayout(
        tagList(
          tags$h4("Checked:"), verbatimTextOutput("checked2")
        ),
        tagList(
          tags$h4("Selected:"), verbatimTextOutput("selected2")
        )
      )

    )
  )
)
