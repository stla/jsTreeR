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
      list(text = "Branch 2", type = "parent")
    )
    jstree(nodes, contextMenu = TRUE)
  })

  output$opened <- renderText({
    req(input[["mytree_full"]])
    paste0(
      "Is node 1 opened?: ",
      input[["mytree_full"]][[1]]$state$opened,
      "\n",
      "Is node 2 opened?: ",
      input[["mytree_full"]][[2]]$state$opened
    )
  })

  observe({
    print(input[["mytree_full"]][[1]]$state)
    print("----------------------------")
    print("----------------------------")
  })
}

shinyApp(ui, server)
