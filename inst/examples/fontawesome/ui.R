shinyUI(
  fluidPage(

    tags$head(
      tags$style(
        HTML(c(
          ".red {color: red;}",
          ".green {color: green;}",
          ".jstree-proton {font-weight: bold;}",
          ".jstree-anchor {font-size: medium;}"
        ))
      )
    ),

    titlePanel("Drag and drop the nodes"),

    fluidRow(
      column(
        width = 4,
        jstreeOutput("jstree")
      ),
      column(
        width = 4,
        tags$fieldset(
          tags$legend("All nodes"),
          verbatimTextOutput("treeState")
        )
      ),
      column(
        width = 4,
        tags$fieldset(
          tags$legend("Selected nodes"),
          verbatimTextOutput("treeSelected")
        )
      )
    )

  )

)
