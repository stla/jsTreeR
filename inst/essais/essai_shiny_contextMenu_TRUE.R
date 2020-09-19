library(jsTreeR)
library(shiny)
library(jsonlite)

nodes <- list(
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
        text = "ChildA2",
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

ui <- fluidPage(

  tags$head(
    tags$style(
      HTML(c(
        ".red {color: red;}",
        ".green {color: green;}",
        ".jstree-proton {font-weight: bold;}",
        ".jstree-anchor {font-size: medium;}",
        "pre {font-weight: bold; line-height: 1;}"
      ))
    )
  ),

  titlePanel("Drag and drop the nodes"),

  fluidRow(
    column(
      width = 3,
      jstreeOutput("jstree")
    ),
    column(
      width = 4,
      tags$fieldset(
        tags$legend(tags$span(style = "color: blue;", "All nodes")),
        verbatimTextOutput("treeState")
      )
    ),
    column(
      width = 4,
      tags$fieldset(
        tags$legend(tags$span(style = "color: blue;", "Selected nodes")),
        verbatimTextOutput("treeSelected")
      )
    )
  )

)

server <- function(input, output){

  output[["jstree"]] <- renderJstree({
    jstree(
      nodes,
      dragAndDrop = TRUE,
      checkboxes = TRUE,
      theme = "proton",
      contextMenu = TRUE
    )
  })

  #observe(print(input[["jstree"]]))

  output[["treeState"]] <- renderPrint({
    toJSON(input[["jstree"]], pretty = TRUE, auto_unbox = TRUE)
  })

  output[["treeSelected"]] <- renderPrint({
    toJSON(input[["jstree_selected"]], pretty = TRUE, auto_unbox = TRUE)
  })

}

shinyApp(ui, server)


