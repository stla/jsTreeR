# Super tiny icons, with 'search' options ####

library(jsTreeR)
library(shiny)
library(jsonlite)

nodes <- fromJSON(
  system.file(
    "htmlwidgets",
    "SuperTinyIcons",
    "SuperTinyIcons.json",
    package = "jsTreeR"
  ),
  simplifyDataFrame = FALSE
)

nnodes <- lapply(nodes, function(node){
  node[["children"]] <- lapply(node[["children"]], function(child){
    child[["data"]] <- list(
      svg = paste0(sub("^supertinyicon-(.*)", "\\1", child[["icon"]]), ".svg")
    )
    child
  })
  node
})

ui <- fluidPage(
  tags$head(tags$style(HTML("#jstree {background-color: #fff5ee;"))),
  titlePanel("Super tiny icons"),
  fluidRow(
    column(
      width = 6,
      jstreeOutput("jstree", height = "auto")
    ),
    column(
      width = 6,
      uiOutput("icon")
    )
  )
)

server <- function(input, output){
  output[["jstree"]] <- renderJstree({
    jstree(nnodes, multiple = FALSE, search = list(
      show_only_matches = TRUE,
      case_sensitive = TRUE,
      search_leaves_only = TRUE
    ))
  })
  output[["icon"]] <- renderUI({
    req(length(input[["jstree_selected"]]) > 0)
    svg <- input[["jstree_selected"]][[1]][["data"]][["svg"]]
    tags$img(src = paste0("/SuperTinyIcons/", svg))
  })
}

if(interactive()){
  shinyApp(ui, server)
}
