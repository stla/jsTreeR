library(jsTreeR)
library(shiny)

nodes1 <- list(
  list(
    text = "RootA",
    data = list(value = 999),
    icon = "far fa-moon red",
    children = list(
      list(
        text = "ChildA1",
        icon = "fa fa-leaf green"
      ),
      list(
        text = "XXXXX",
        icon = "fa fa-leaf green"
      )
    )
  ),
  list(
    text = "RootB",
    icon = "far fa-moon red",
    children = list(
      list(
        text = "ChildB1",
        icon = "fa fa-leaf green"
      ),
      list(
        text = "ChildB2",
        icon = "fa fa-leaf green"
      )
    )
  )
)

nodes2 <- list(
  list(
    text = "NewRootA",
    icon = "fas fa-dog",
    children = list(
      list(
        text = "ChildA1",
        icon = "fas fa-cat"
      ),
      list(
        text = "ChildA2",
        icon = "fas fa-cat"
      )
    )
  ),
  list(
    text = "NewRootB",
    icon = "fas fa-dog",
    children = list(
      list(
        text = "ChildB1",
        icon = "fas fa-cat"
      ),
      list(
        text = "ChildB2",
        icon = "fas fa-cat"
      )
    )
  )
)

thetree <- jstree(nodes1, search = TRUE)

ui <- fluidPage(
  br(),
  actionButton("update", "Update tree"),
  br(),
  jstreeOutput("tree")
)

server <- function(input, output, session) {

  output[["tree"]] <- renderJstree({
    thetree
  })

  observeEvent(input[["update"]], {
    jstreeUpdate(session, "tree", nodes2)
  })

}

shinyApp(ui, server)
