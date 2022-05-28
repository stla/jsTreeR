library(shiny)
library(jsTreeR)

css <- HTML("
  .flexcol {
    display: flex;
    flex-direction: column;
    width: 100%;
    margin: 0;
  }
  .stretch {
    flex-grow: 1;
    height: 1px;
  }
  .bottomright {
    position: fixed;
    bottom: 0;
    right: 15px;
    min-width: calc(50% - 15px);
  }
")

ui <- fixedPage(
  tags$head(
    tags$style(css)
  ),
  class = "flexcol",

  br(),

  fixedRow(
    column(
      width = 6,
      treeNavigatorUI("explorer")
    ),
    column(
      width = 6,
      tags$div(class = "stretch"),
      tags$fieldset(
        class = "bottomright",
        tags$legend(
          tags$h1("Selections:", style = "float: left;"),
          downloadButton(
            "dwnld",
            class = "btn-primary btn-lg",
            style = "float: right;",
            icon  = icon("save")
          )
        ),
        verbatimTextOutput("selections")
      )
    )
  )
)

server <- function(input, output, session){

  Paths <- treeNavigatorServer(
    "explorer", rootFolder = getwd(),
    search = list( # (search in the visited folders only)
      show_only_matches  = TRUE,
      case_sensitive     = TRUE,
      search_leaves_only = TRUE
    )
  )

  output[["selections"]] <- renderPrint({
    cat(Paths(), sep = "\n")
  })

}

shinyApp(ui, server)
