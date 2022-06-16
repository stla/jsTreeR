shinyUI(
  fluidPage(
    tags$head(
      tags$style(HTML(css))
    ),
    br(),
    fluidRow(
      column(
        width = 4,
        tags$h1("Icons from images"),
        tags$hr(),
        jstreeOutput("mytree")
      ),
      column(
        width = 8,
        tags$h3("The images are in the www folder."),
        br(),
        uiOutput("png")
      )
    )
  )
)
