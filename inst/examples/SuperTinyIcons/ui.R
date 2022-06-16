shinyUI(
  fluidPage(
    tags$head(
      tags$style(
        HTML(css)
      )
    ),
    class = "flexcol",
    br(),
    helpText(
      "This example illustrates some 'search' options."
    ),
    tags$hr(),

    titlePanel("Super tiny icons"),
    fluidRow(
      column(
        width = 6,
        jstreeOutput("jstree", height = "auto")
      ),
      column(
        width = 6,
        tags$div(class = "stretch"),
        tags$div(
          class = "bottomright",
          tags$div(
            uiOutput("icon"),
            checkboxInput("transparent", "Transparent background")
          )
        )
      )
    )
  )
)
