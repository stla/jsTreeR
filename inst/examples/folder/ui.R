shinyUI(
  fluidPage(
    br(),
    fluidRow(
      column(
        width = 4,
        div(
          style = "background-color: lemonchiffon;",
          checkboxInput("leavesOnly", "Leaves only", TRUE)
        ),
        jstreeOutput("jstree")
      ),
      column(
        width = 4,
        tags$fieldset(
          tags$legend("Selections - JSON format"),
          verbatimTextOutput("treeSelected_json")
        )
      ),
      column(
        width = 4,
        tags$fieldset(
          tags$legend("Selections - R list"),
          verbatimTextOutput("treeSelected_R")
        )
      )
    )
  )
)
