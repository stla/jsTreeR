library(jsTreeR)
library(shiny)
library(htmlwidgets)
library(magrittr)

onrender <- c(
  "function(el, x) {",
  "  Shiny.addCustomMessageHandler('hideNodes', function(threshold) {",
  "    var tree = $.jstree.reference(el.id);",
  "    var json = tree.get_json(null, {flat: true});",
  "    for(var i = 0; i < json.length; i++) {",
  "      if(tree.is_leaf(json[i].id) && json[i].text <= threshold) {",
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
      sliderInput(
        "threshold",
        label = "Threshold",
        min = 0, max = 10, value = 0, step = 1
      )
    )
  )
)

server <- function(input, output, session){

  output[["tree"]] <- renderJstree({
    jstree(nodes, checkboxes = TRUE) %>% onRender(onrender)
  })

  observeEvent(input[["threshold"]], {
    session$sendCustomMessage("hideNodes", input[["threshold"]])
  })

}

shinyApp(ui, server)
