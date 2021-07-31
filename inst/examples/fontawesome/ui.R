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

    br(),

    helpText(
      "This example illustrates the drag-and-drop functionality,",
      "the checkboxes, the proton theme, and the fontawesome icons."
    ),

    tags$hr(),

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
          tags$legend("Selected nodes (leaves only)"),
          verbatimTextOutput("treeSelected")
        )
      )
    )

  )

)
