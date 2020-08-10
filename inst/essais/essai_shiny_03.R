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
nodes <- Filter(function(node) node$text %in% c("Browsers", "Google"), nodes)

ui <- fluidPage(
  tags$head(tags$style(HTML("#jstree {background-color: #fff5ee;"))),
  titlePanel("Super tiny icons (subset)"),
  fluidRow(
    column(
      width = 12,
      jstreeOutput("jstree", height = "auto")
    )
  )
)

server <- function(input, output){
  output[["jstree"]] <- renderJstree(jstree(nodes, search = TRUE))
}

shinyApp(ui, server)


