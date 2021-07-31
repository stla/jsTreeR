library(jsTreeR)
library(shiny)

dnd <- list(
  always_copy = TRUE
)

nodes1 <- list(
  list(
    text = "RootA",
    type = "root",
    children = list(
      list(
        text = "ChildA1",
        type = "child"
      ),
      list(
        text = "ChildA2",
        type = "child"
      )
    )
  ),
  list(
    text = "RootB",
    type = "root",
    children = list(
      list(
        text = "ChildB1",
        type = "child"
      ),
      list(
        text = "ChildB2",
        type = "child"
      )
    )
  )
)

nodes2 <- list(
  list(
    text = "FatherA",
    type = "root",
    children = list(
      list(
        text = "SonA1",
        type = "child"
      ),
      list(
        text = "SonA2",
        type = "child"
      )
    )
  ),
  list(
    text = "FatherB",
    type = "root",
    children = list(
      list(
        text = "SonB1",
        type = "child"
      ),
      list(
        text = "SonB2",
        type = "child"
      )
    )
  )
)

types <- list(
  root = list(
    icon = "glyphicon glyphicon-ok"
  ),
  child = list(
    icon = "glyphicon glyphicon-file"
  )
)


ui <- fluidPage(
  fluidRow(
    column(
      6,
      jstreeOutput("tree1")
    ),
    column(
      6,
      jstreeOutput("tree2")
    )
  )
)

server <- function(input, output, session){

  output[["tree1"]] <- renderJstree({
    jstree(
      nodes1,
      dragAndDrop = TRUE, dnd = dnd,
      types = types
    )
  })

  output[["tree2"]] <- renderJstree({
    jstree(
      nodes2,
      dragAndDrop = TRUE, dnd = dnd,
      types = types
    )
  })

}

shinyApp(ui, server)

