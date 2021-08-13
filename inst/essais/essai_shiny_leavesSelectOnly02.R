library(jsTreeR)
library(shiny)

nodes <- list(
  list(
    text = "RootA",
    children = list(
      list(
        text = "ChildA1"
      ),
      list(
        text = "ChildA2"
      )
    )
  ),
  list(
    text = "RootB",
    children = list(
      list(
        text = "ChildB1"
      ),
      list(
        text = "ChildB2"
      )
    )
  )
)

ui <- fluidPage(

  fluidRow(
    column(
      width = 6,
      jstreeOutput("jstree")
    ),
    column(
      width = 6,
      tags$fieldset(
        tags$legend("Selections"),
        verbatimTextOutput("Selections")
      )
    )
  )

)

server <- function(input, output){

  output[["jstree"]] <- renderJstree({
    jstree(
      nodes, checkboxes = TRUE, theme = "proton",
      selectLeavesOnly = TRUE # <-- new option
    )
  })

  output[["Selections"]] <- renderPrint({
    input[["jstree_selected"]]
  })

}

shinyApp(ui, server)
