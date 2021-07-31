shinyUI(
  fluidPage(
    tags$h3("Open a node and filter with the slider."),
    br(),
    fluidRow(
      column(
        6,
        jstreeOutput("tree")
      ),
      column(
        6,
        sliderInput(
          "range",
          label = "Population",
          min = 0, max = 100000000, value = c(0, 100000000)
        )
      )
    )
  )
)
