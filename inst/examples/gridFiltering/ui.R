shinyUI(
  fluidPage(
    tags$head(
      tags$style(
        HTML(c(
          ".lightorange {background-color: #fed8b1;}",
          ".lightgreen {background-color: #98ff98;}",
          "#tree {background-color: #98ff98;}",
          ".jstree-container-ul>li>a {",
          "  font-weight: bold; font-style: italic; font-size: large;",
          "}",
          ".yellow {background-color: yellow !important;}",
          ".centered {text-align: center;}",
          ".jstree-children>li>a {",
          "  font-weight: 700; font-family: Helvetica; font-size: larger;",
          "}"
        ))
      )
    ),
    tags$h3("Open a node and filter with the slider."),
    br(),
    sliderInput(
      "range",
      label = "Population",
      min = 0, max = 100000000, value = c(0, 100000000),
      width = "850px"
    ),
    br(),
    jstreeOutput("tree")
  )
)
