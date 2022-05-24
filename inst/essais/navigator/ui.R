shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "navigator.css"),
    tags$script(src = "navigator.js")
  ),
  br(),
  jstreeOutput("navigator")
))
