library(jsTreeR)
library(shiny)

nodes <- list(
  list(
    text = "RootA",
    data = list(group = TRUE),
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
    data = list(group = TRUE),
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
    jstree(nodes, checkboxes = TRUE, theme = "proton", selectLeavesOnly = FALSE)
  })

  # selections <- eventReactive(input[["jstree_selected"]], {
  #   selectedNodes <- Filter(
  #     function(x) !isTRUE(x$data$group),
  #     input[["jstree_selected"]]
  #   )
  #   lapply(selectedNodes, `[[`, "text")
  # })

  output[["Selections"]] <- renderPrint({
    input[["jstree_selected"]]
  })

}

shinyApp(ui, server)
