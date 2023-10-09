library(jsTreeR)
library(shiny)

ui <- fluidPage(
  textInput("test", "test"),
  jstreeOutput("mytree"),
  textOutput("opened")
)

server <- function(input, output, session){
  output[["mytree"]] <- renderJstree({
    # jstreeDestroy(session, id = "mytree")
    nodes <- list(
      list(
        text = paste0(input$test, "Branch 1"),
        state = list(opened = TRUE, disabled = FALSE),
        type = "parent",
        children = list(
          list(text = "Leaf A", type = "child"),
          list(text = "Leaf B", type = "child"),
          list(text = "Leaf C", type = "child"),
          list(text = "Leaf D", type = "child")
        )
      ),
      list(text = "Branch 2", type = "parent", state = list(opened = TRUE))
    )
    jstree(nodes, contextMenu = TRUE)
  })

  output$opened <- renderText({
    if(isTruthy(input[["mytree_full"]])){
      paste("Is node 1 opened?:", input[["mytree_full"]][[1]]$state$opened)
    }
  })

  observe({
    print(input[["mytree_full"]][[1]]$state)
    print("----------------------------")
    print("----------------------------")
  })
}

shinyApp(ui, server)
