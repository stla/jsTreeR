library(jsTreeR)
library(shiny)
library(jsonlite)

dat <- list(
  list(
    text = "RootA",
    data = list(value = 999),
    icon = "glyphicon glyphicon-folder-open",
    children = list(
      list(
        text = "ChildA1",
        icon = "glyphicon glyphicon-file",
        children = list(
          list(
            text = "XXX"
          )
        )
      ),
      list(
        text = "ChildA2",
        icon = "glyphicon glyphicon-file"
      )
    )
  ),
  list(
    text = "RootB",
    icon = "glyphicon glyphicon-folder-open",
    children = list(
      list(
        text = "ChildB1",
        icon = "glyphicon glyphicon-file"
      ),
      list(
        text = "ChildB2",
        icon = "glyphicon glyphicon-file"
      )
    )
  )
)


ui <- fluidPage(
  br(),
  fluidRow(
    column(
      width = 6,
      jstreeOutput("jstree")
    ),
    column(
      width = 6,
      verbatimTextOutput("treeState"),
      br(),
      verbatimTextOutput("treeSelected")
    )
  )
)

server <- function(input, output){

  output[["jstree"]] <-
    renderJstree(jstree(dat, dragAndDrop = TRUE))

  output[["treeState"]] <- renderPrint({
    toJSON(input[["jstree"]], pretty = TRUE, auto_unbox = TRUE)
  })

  output[["treeSelected"]] <- renderPrint({
    toJSON(input[["jstree_selected"]], pretty = TRUE, auto_unbox = TRUE)
  })

}

shinyApp(ui, server)


