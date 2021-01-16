library(jsTreeR)
library(shiny)
library(htmlwidgets)

onrender <- c(
  "function(el, x) {",
  "  Shiny.addCustomMessageHandler('hideNodes', function(threshold) {",
  "    var tree = $.jstree.reference(el.id);",
  "    var json = tree.get_json(null, {flat: true});",
  "    for(var i = 0; i < json.length; i++) {",
  "      if(json[i].text <= 1) {",
  "        tree.hide_node(json[i].id);",
  "      } else {",
  "        tree.show_node(json[i].id);",
  "      }",
  "    }",
  "  });",
  "}"
)

nodes <- list(
  list(
    text = "1-3a",
    children = list(
      list(
        text = "1"
      ),
      list(
        text = "2"
      ),
      list(
        text = "3"
      )
    )
  ),
  list(
    text = "1-3b",
    children = list(
      list(
        text = "1"
      ),
      list(
        text = "2"
      ),
      list(
        text = "3"
      )
    )
  ),
  list(
    text = "4-6",
    children = list(
      list(
        text = "4"
      ),
      list(
        text = "5"
      ),
      list(
        text = "6"
      )
    )
  )
)

ui <- fluidPage(
  br(),
  fluidRow(
    column(
      3,
      jstreeOutput("tree")
    ),
    column(
      9,
      verbatimTextOutput("state")
    )
  )
)

server <- function(input, output){

  output[["tree"]] <- renderJstree({
    jstree(nodes) %>% onRender(onrender)
  })

  output[["state"]] <- renderPrint({
    input[["tree_full"]]
  })

}

shinyApp(ui, server)
