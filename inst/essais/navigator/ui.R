shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "navigator.css"),
    tags$script(src = "navigator.js")
  ),
  br(),
  conditionalPanel(
    condition = "!output.choice",
    fluidRow(
      column(
        width = 12,
        shinyDirButton(
          "rootfolder",
          label = "Browse to choose a root folder",
          title = "Choose a folder",
          buttonType = "primary",
          class = "btn-block"
        )
      )
    )
  ),
  conditionalPanel(
    condition = "output.choice",
    style = "display: none;",
    fluidRow(
      column(
        width = 6,
        jstreeOutput("navigator")
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
))
