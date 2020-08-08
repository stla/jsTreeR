library(jsTreeR)
library(shiny)
library(jsonlite)

nodes <- fromJSON(
  system.file(
    "htmlwidgets",
    "SuperTinyIcons",
    "SuperTinyIcons.json",
    package = "jsTreeR"
  ),
  simplifyDataFrame = FALSE
)

ui <- fluidPage(
  titlePanel("SuperTinyIcons"),
  fluidRow(
    column(
      width = 12,
      jstreeOutput("jstree")
    )
  )
)

server <- function(input, output){

  output[["jstree"]] <- renderJstree(jstree(nodes))

}

shinyApp(ui, server)


