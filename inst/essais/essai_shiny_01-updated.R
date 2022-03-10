library(jsTreeR)
library(shiny)
library(jsonlite)
library(shinyWidgets)

nodes <- list(
  list(
    text = "RootA",
    data = list(value = 999),
    icon = "far fa-moon red",
    children = list(
      list(
        text = "ChildA1",
        icon = "fa fa-leaf green"
      ),
      list(
        text = "ChildA2",
        data = list(value = 11111),
        icon = "fa fa-leaf green"
      )
    )
  ),
  list(
    text = "RootB",
    icon = "far fa-moon red",
    children = list(
      list(
        text = "ChildB1",
        icon = "fa fa-leaf green"
      ),
      list(
        text = "ChildB2",
        icon = "fa fa-leaf green"
      )
    )
  )
)

ui <- fluidPage(

  tags$head(
    tags$style(
      HTML(c(
        ".red {color: red;}",
        ".green {color: green;}",
        ".jstree-proton {font-weight: bold;}",
        ".jstree-anchor {font-size: medium;}",
        "pre {font-weight: bold; line-height: 1;}",
        "div.state.p-info>label>span {font-weight: bold;}"
      ))
    )
  ),

  titlePanel("Drag and drop the nodes"),

  fluidRow(
    column(
      width = 3,
      jstreeOutput("jstree")
    ),
    column(
      width = 4,
      tags$fieldset(
        tags$legend(tags$span(style = "color: blue;", "All nodes")),
        verbatimTextOutput("treeState")
      )
    ),
    column(
      width = 4,
      tags$fieldset(
        tags$legend(tags$span(style = "color: blue;", "Selected nodes")),
        prettyRadioButtons(
          "selections",
          label = NULL,
          status = "info",
          shape = "round",
          thick = TRUE,
          inline = TRUE,
          choiceNames = list(
            "Nodes with their 'text' field",
            "Nodes with their path",
            "From root"
          ),
          choiceValues = list(
            "text", "path", "tree"
          )
        ),
        uiOutput("selectedNodes")
      )
    )
  )

)

server <- function(input, output){

  output[["jstree"]] <- renderJstree({
    jstree(nodes, dragAndDrop = TRUE, checkboxes = TRUE, theme = "proton")
  })

  output[["treeState"]] <- renderPrint({
    toJSON(input[["jstree"]], pretty = TRUE, auto_unbox = TRUE)
  })

  output[["nodes_text"]] <- renderPrint({
    toJSON(input[["jstree_selected"]], pretty = TRUE, auto_unbox = TRUE)
  })
  output[["nodes_path"]] <- renderPrint({
    toJSON(input[["jstree_selected_paths"]], pretty = TRUE, auto_unbox = TRUE)
  })
  output[["nodes_tree"]] <- renderPrint({
    toJSON(input[["jstree_selected_tree"]], pretty = TRUE, auto_unbox = TRUE)
  })

  output[["selectedNodes"]] <- renderUI({
    choice <- input[["selections"]]
    if(choice == "text"){
      verbatimTextOutput("nodes_text")
    }else if(choice == "path"){
      verbatimTextOutput("nodes_path")
    }else{
      verbatimTextOutput("nodes_tree")
    }
  })

}

shinyApp(ui, server)


