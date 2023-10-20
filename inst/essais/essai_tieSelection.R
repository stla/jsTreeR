library(shiny)
library(jsTreeR)

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
  jstreeOutput("myTree")
)

server <- function(input, output, session){
  output[["myTree"]] <- renderJstree({
    suppressMessages(
      jstree(
        nodes,
        checkboxes = TRUE,
        tieSelection = FALSE,
        dragAndDrop = TRUE
      )
    )
  })

  observe({
    print(input$myTree_selected)
    print("____________________")
  })
}

shinyApp(ui, server)
