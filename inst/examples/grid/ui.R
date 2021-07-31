shinyUI(
  fluidPage(
    tags$head(
      tags$style(
        HTML(c(
          ".lightorange {background-color: #fed8b1;}",
          ".lightgreen {background-color: #98ff98;}",
          ".bolditalic {font-weight: bold; font-style: italic; font-size: large;}",
          ".yellow {background-color: yellow !important;}",
          ".centered {text-align: center; font-family: cursive;}",
          ".helvetica {font-weight: 700; font-family: Helvetica; font-size: larger;}"
        ))
      )
    ),
    titlePanel("jsTree grid"),
    jstreeOutput("jstree")
  )
)
