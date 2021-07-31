shinyUI(
  fluidPage(
    tags$head(
      tags$style(
        HTML(
          "#jstree {background-color: #fff5ee;}",
          "img {background-color: #333; padding: 50px;}"
        )
      )
    ),
    titlePanel("Super tiny icons"),
    fluidRow(
      column(
        width = 6,
        jstreeOutput("jstree", height = "auto")
      ),
      column(
        width = 6,
        checkboxInput("transparent", "Transparent background"),
        uiOutput("icon")
      )
    )
  )
)
