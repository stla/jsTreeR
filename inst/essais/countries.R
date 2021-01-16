# library(jsonlite)
# dd <- fromJSON("https://gist.githubusercontent.com/tiagodealmeida/0b97ccf117252d742dddf098bc6cc58a/raw/f621703926fc13be4f618fb4a058d0454177cceb/countries.json")
# Countries <- dd$countries$country

# Filtering ####
library(jsTreeR)
library(shiny)
library(htmlwidgets)
library(magrittr)

data("Countries")
rownames(Countries) <- Countries[["countryName"]]
dat <- split(Countries, Countries[["continentName"]])
nodes <- lapply(names(dat), function(continent){
  list(
    text = continent,
    children = lapply(dat[[continent]][["countryName"]], function(cntry){
      list(
        text = cntry,
        data = list(population = Countries[cntry, "population"])
      )
    })
  )
})

onrender <- c(
  "function(el, x) {",
  "  Shiny.addCustomMessageHandler('hideNodes', function(range) {",
  "    var tree = $.jstree.reference(el.id);",
  "    var json = tree.get_json(null, {flat: true});",
  "    for(var i = 0; i < json.length; i++) {",
  "      var id = json[i].id;",
  "      if(tree.is_leaf(id)) {",
  "        var pop = json[i].data.population;",
  "        if(pop < range[0] || pop > range[1]) {",
  "          tree.hide_node(id);",
  "        } else {",
  "          tree.show_node(id);",
  "        }",
  "      }",
  "    }",
  "  });",
  "}"
)

ui <- fluidPage(
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

server <- function(input, output, session){

  output[["tree"]] <- renderJstree({
    jstree(nodes, checkboxes = TRUE) %>% onRender(onrender)
  })

  observeEvent(input[["range"]], {
    session$sendCustomMessage("hideNodes", input[["range"]])
  })

}

shinyApp(ui, server)
