library(shiny)
library(jsTreeR)

ui <- fluidPage(

  fluidRow(
    column(
      width = 6,
      treeNavigatorUI("xx")
    ),
    column(
      width = 6,
      tags$fieldset(
        tags$legend(
          tags$h1("Selections:", style = "float: left;"),
          downloadButton(
            "dwnld",
            class = "btn-primary btn-lg",
            icon = icon("save"),
            style = "float: right;"
          )
        ),
        verbatimTextOutput("selections")
      )
    )
  )

)

server <- function(input, output, session){

  Paths <- treeNavigatorServer(
    "xx", rootFolder = "C:/SL/MyPackages"
  )

  output[["selections"]] <- renderPrint({
    cat(Paths(), sep = "\n")
  })

}

shinyApp(ui, server)
