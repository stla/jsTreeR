library(jsTreeR)
library(shiny)
library(jsonlite)

nodes <- list(
  list(
    text = "Branch 1",
    state = list(
      opened = TRUE,
      disabled = FALSE,
      selected = FALSE,
      undetermined = TRUE
    ),
    type = "parent",
    children = list(
      list(
        text = "Leaf A",
        state = list(
          opened = TRUE,
          disabled = FALSE,
          selected = FALSE,
          checked = FALSE,
          undetermined = FALSE
        ),
        type = "child"
      ),
      list(
        text = "Leaf B",
        state = list(
          opened = TRUE,
          disabled = FALSE,
          selected = FALSE,
          checked = FALSE,
          undetermined = FALSE
        ),
        type = "child"
      ),
      list(
        text = "Leaf C",
        state = list(
          opened = TRUE,
          disabled = FALSE,
          selected = FALSE,
          checked = TRUE,
          undetermined = FALSE
        ),
        type = "child"
      ),
      list(
        text = "Leaf D",
        state = list(
          opened = TRUE,
          disabled = FALSE,
          selected = FALSE,
          checked = TRUE,
          undetermined = FALSE
        ),
        type = "child"
      )
    )
  ),
  list(
    text = "Branch 2",
    type = "parent",
    state = list(
      opened = TRUE,
      disabled = FALSE,
      selected = FALSE,
      checked = TRUE,
      undetermined = FALSE
    )
  )
)

ui <- fluidPage(jstreeOutput("mytree"),  verbatimTextOutput("mytree_full"))

server <- function(input, output, session) {
  output[["mytree"]] <- renderJstree({
    jstree(nodes, contextMenu = TRUE, checkboxes = TRUE, checkWithText = FALSE)
  })

  output$mytree_full <-  renderPrint({toJSON(input$mytree_full, pretty = TRUE)})
}



shinyApp(ui, server)
