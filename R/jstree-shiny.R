#' Shiny bindings for jstree
#'
#' Output and render functions for using jstree within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended
#' @param expr an expression that generates a \code{\link{jstree}}
#' @param env the environment in which to evaluate \code{expr}
#' @param quoted logical, whether \code{expr} is a quoted expression
#'   (with \code{quote()}); this is useful if you want to save an expression
#'   in a variable
#'
#' @name jstree-shiny
#'
#' @importFrom htmlwidgets shinyWidgetOutput shinyRenderWidget
#' @export
#'
#' @examples # displaying a folder ####
#'
#' library(jsTreeR)
#' library(shiny)
#' library(jsonlite)
#'
#' # make the nodes list from a vector of file paths
#' makeNodes <- function(leaves){
#'   dfs <- lapply(strsplit(leaves, "/"), function(s){
#'     item <-
#'       Reduce(function(a,b) paste0(a,"/",b), s[-1], s[1], accumulate = TRUE)
#'     data.frame(
#'       item = item,
#'       parent = c("root", item[-length(item)]),
#'       stringsAsFactors = FALSE
#'     )
#'   })
#'   dat <- dfs[[1]]
#'   for(i in 2:length(dfs)){
#'     dat <- merge(dat, dfs[[i]], all = TRUE)
#'   }
#'   f <- function(parent){
#'     i <- match(parent, dat$item)
#'     item <- dat$item[i]
#'     children <- dat$item[dat$parent==item]
#'     label <- tail(strsplit(item, "/")[[1]], 1)
#'     if(length(children)){
#'       list(
#'         text = label,
#'         data = list(value = item),
#'         children = lapply(children, f)
#'       )
#'     }else{
#'       list(text = label, data = list(value = item))
#'     }
#'   }
#'   lapply(dat$item[dat$parent == "root"], f)
#' }
#'
#' folder <-
#'   list.files(system.file("www", "shared", package = "shiny"), recursive = TRUE)
#' nodes <- makeNodes(folder)
#'
#' ui <- fluidPage(
#'   br(),
#'   fluidRow(
#'     column(
#'       width = 4,
#'       jstreeOutput("jstree")
#'     ),
#'     column(
#'       width = 4,
#'       tags$fieldset(
#'         tags$legend("Selections - JSON format"),
#'         verbatimTextOutput("treeSelected_json")
#'       )
#'     ),
#'     column(
#'       width = 4,
#'       tags$fieldset(
#'         tags$legend("Selections - R list"),
#'         verbatimTextOutput("treeSelected_R")
#'       )
#'     )
#'   )
#' )
#'
#' server <- function(input, output){
#'
#'   output[["jstree"]] <-
#'     renderJstree(
#'       jstree(nodes, search = TRUE, checkboxes = TRUE)
#'     )
#'
#'   output[["treeSelected_json"]] <- renderPrint({
#'     toJSON(input[["jstree_selected"]], pretty = TRUE, auto_unbox = TRUE)
#'   })
#'
#'   output[["treeSelected_R"]] <- renderPrint({
#'     input[["jstree_selected"]]
#'   })
#'
#' }
#'
#' if(interactive()){
#'   shinyApp(ui, server)
#' }
#'
#'
#' # drag-and-drop, checkboxes, proton theme, fontawesome icons ####
#'
#' library(jsTreeR)
#' library(shiny)
#' library(jsonlite)
#'
#' nodes <- list(
#'   list(
#'     text = "RootA",
#'     data = list(value = 999),
#'     icon = "far fa-moon red",
#'     children = list(
#'       list(
#'         text = "ChildA1",
#'         icon = "fa fa-leaf green"
#'       ),
#'       list(
#'         text = "ChildA2",
#'         icon = "fa fa-leaf green"
#'       )
#'     )
#'   ),
#'   list(
#'     text = "RootB",
#'     icon = "far fa-moon red",
#'     children = list(
#'       list(
#'         text = "ChildB1",
#'         icon = "fa fa-leaf green"
#'       ),
#'       list(
#'         text = "ChildB2",
#'         icon = "fa fa-leaf green"
#'       )
#'     )
#'   )
#' )
#'
#' ui <- fluidPage(
#'
#'   tags$head(
#'     tags$style(
#'       HTML(c(
#'         ".red {color: red;}",
#'         ".green {color: green;}",
#'         ".jstree-proton {font-weight: bold;}",
#'         ".jstree-anchor {font-size: medium;}"
#'       ))
#'     )
#'   ),
#'
#'   titlePanel("Drag and drop the nodes"),
#'
#'   fluidRow(
#'     column(
#'       width = 4,
#'       jstreeOutput("jstree")
#'     ),
#'     column(
#'       width = 4,
#'       tags$fieldset(
#'         tags$legend("All nodes"),
#'         verbatimTextOutput("treeState")
#'       )
#'     ),
#'     column(
#'       width = 4,
#'       tags$fieldset(
#'         tags$legend("Selected nodes"),
#'         verbatimTextOutput("treeSelected")
#'       )
#'     )
#'   )
#'
#' )
#'
#' server <- function(input, output){
#'
#'   output[["jstree"]] <- renderJstree({
#'     jstree(nodes, dragAndDrop = TRUE, checkboxes = TRUE, theme = "proton")
#'   })
#'
#'   output[["treeState"]] <- renderPrint({
#'     toJSON(input[["jstree"]], pretty = TRUE, auto_unbox = TRUE)
#'   })
#'
#'   output[["treeSelected"]] <- renderPrint({
#'     toJSON(input[["jstree_selected"]], pretty = TRUE, auto_unbox = TRUE)
#'   })
#'
#' }
#'
#' if(interactive()){
#'   shinyApp(ui, server)
#' }
#'
#'
#' # Super tiny icons, with 'search' options ####
#'
#' library(jsTreeR)
#' library(shiny)
#' library(jsonlite)
#'
#' nodes <- fromJSON(
#'   system.file(
#'     "htmlwidgets",
#'     "SuperTinyIcons",
#'     "SuperTinyIcons.json",
#'     package = "jsTreeR"
#'   ),
#'   simplifyDataFrame = FALSE
#' )
#'
#' ui <- fluidPage(
#'   tags$head(
#'     tags$style(
#'       HTML(
#'         "#jstree {background-color: #fff5ee;}",
#'         "img {background-color: #333; padding: 50px;}"
#'       )
#'     )
#'   ),
#'   titlePanel("Super tiny icons"),
#'   fluidRow(
#'     column(
#'       width = 6,
#'       jstreeOutput("jstree", height = "auto")
#'     ),
#'     column(
#'       width = 6,
#'       checkboxInput("transparent", "Transparent background"),
#'       uiOutput("icon")
#'     )
#'   )
#' )
#'
#' server <- function(input, output){
#'   output[["jstree"]] <- renderJstree({
#'     jstree(nodes, multiple = FALSE, search = list(
#'       show_only_matches = TRUE,
#'       case_sensitive = TRUE,
#'       search_leaves_only = TRUE
#'     ))
#'   })
#'   output[["icon"]] <- renderUI({
#'     req(length(input[["jstree_selected"]]) > 0)
#'     svg <- req(input[["jstree_selected"]][[1]][["data"]][["svg"]])
#'     if(input[["transparent"]])
#'       svg <- paste0("transparent-", svg)
#'     tags$img(src = paste0("/SuperTinyIcons/", svg), width = "75%")
#'   })
#' }
#'
#' if(interactive()){
#'   shinyApp(ui, server)
#' }
#'
#'
#' # grid example ####
#'
#' library(jsTreeR)
#' library(shiny)
#'
#' nodes <- list(
#'   list(
#'     text = "Fruits",
#'     type = "fruit",
#'     icon = "supertinyicon-transparent-raspberry_pi",
#'     a_attr = list(class = "helvetica"),
#'     children = list(
#'       list(
#'         text = "Apple",
#'         type = "fruit",
#'         data = list(
#'           price = 0.1,
#'           quantity = 20,
#'           cssclass = "lightorange"
#'         )
#'       ),
#'       list(
#'         text = "Banana",
#'         type = "fruit",
#'         data = list(
#'           price = 0.2,
#'           quantity = 31,
#'           cssclass = "lightorange"
#'         )
#'       ),
#'       list(
#'         text = "Grapes",
#'         type = "fruit",
#'         data = list(
#'           price = 1.99,
#'           quantity = 34,
#'           cssclass = "lightorange"
#'         )
#'       ),
#'       list(
#'         text = "Mango",
#'         type = "fruit",
#'         data = list(
#'           price = 0.5,
#'           quantity = 8,
#'           cssclass = "lightorange"
#'         )
#'       ),
#'       list(
#'         text = "Melon",
#'         type = "fruit",
#'         data = list(
#'           price = 0.8,
#'           quantity = 4,
#'           cssclass = "lightorange"
#'         )
#'       ),
#'       list(
#'         text = "Pear",
#'         type = "fruit",
#'         data = list(
#'           price = 0.1,
#'           quantity = 30,
#'           cssclass = "lightorange"
#'         )
#'       ),
#'       list(
#'         text = "Strawberry",
#'         type = "fruit",
#'         data = list(
#'           price = 0.15,
#'           quantity = 32,
#'           cssclass = "lightorange"
#'         )
#'       )
#'     ),
#'     state = list(
#'       opened = TRUE
#'     )
#'   ),
#'   list(
#'     text = "Vegetables",
#'     type = "vegetable",
#'     icon = "supertinyicon-transparent-vegetarian",
#'     a_attr = list(class = "helvetica"),
#'     children = list(
#'       list(
#'         text = "Aubergine",
#'         type = "vegetable",
#'         data = list(
#'           price = 0.5,
#'           quantity = 8,
#'           cssclass = "lightgreen"
#'         )
#'       ),
#'       list(
#'         text = "Broccoli",
#'         type = "vegetable",
#'         data = list(
#'           price = 0.4,
#'           quantity = 22,
#'           cssclass = "lightgreen"
#'         )
#'       ),
#'       list(
#'         text = "Carrot",
#'         type = "vegetable",
#'         data = list(
#'           price = 0.1,
#'           quantity = 32,
#'           cssclass = "lightgreen"
#'         )
#'       ),
#'       list(
#'         text = "Cauliflower",
#'         type = "vegetable",
#'         data = list(
#'           price = 0.45,
#'           quantity = 18,
#'           cssclass = "lightgreen"
#'         )
#'       ),
#'       list(
#'         text = "Potato",
#'         type = "vegetable",
#'         data = list(
#'           price = 0.2,
#'           quantity = 38,
#'           cssclass = "lightgreen"
#'         )
#'       )
#'     )
#'   )
#' )
#'
#' grid <- list(
#'   columns = list(
#'     list(
#'       width = 200,
#'       header = "Product",
#'       headerClass = "bolditalic yellow centered",
#'       wideValueClass = "cssclass"
#'     ),
#'     list(
#'       width = 150,
#'       value = "price",
#'       header = "Price",
#'       wideValueClass = "cssclass",
#'       headerClass = "bolditalic yellow centered",
#'       wideCellClass = "centered"
#'     ),
#'     list(
#'       width = 150,
#'       value = "quantity",
#'       header = "Quantity",
#'       wideValueClass = "cssclass",
#'       headerClass = "bolditalic yellow centered",
#'       wideCellClass = "centered"
#'     )
#'   ),
#'   width = 600
#' )
#'
#' types <- list(
#'   fruit = list(
#'     a_attr = list(
#'       class = "lightorange"
#'     ),
#'     icon = "supertinyicon-transparent-symantec"
#'   ),
#'   vegetable = list(
#'     a_attr = list(
#'       class = "lightgreen"
#'     ),
#'     icon = "supertinyicon-transparent-symantec"
#'   )
#' )
#'
#' ui <- fluidPage(
#'   tags$head(
#'     tags$style(
#'       HTML(c(
#'         ".lightorange {background-color: #fed8b1;}",
#'         ".lightgreen {background-color: #98ff98;}",
#'         ".bolditalic {font-weight: bold; font-style: italic; font-size: large;}",
#'         ".yellow {background-color: yellow !important;}",
#'         ".centered {text-align: center; font-family: cursive;}",
#'         ".helvetica {font-weight: 700; font-family: Helvetica; font-size: larger;}"
#'       ))
#'     )
#'   ),
#'   titlePanel("jsTree grid"),
#'   jstreeOutput("jstree")
#' )
#'
#' server <- function(input, output){
#'   output[["jstree"]] <-
#'     renderJstree(jstree(nodes, grid = grid, types = types))
#' }
#'
#' if(interactive()){
#'   shinyApp(ui, server)
#' }
#'
#'
#' # Filtering ####
#'
#' library(jsTreeR)
#' library(shiny)
#' library(htmlwidgets)
#' library(magrittr)
#'
#' data("Countries")
#' rownames(Countries) <- Countries[["countryName"]]
#' dat <- split(Countries, Countries[["continentName"]])
#' nodes <- lapply(names(dat), function(continent){
#'   list(
#'     text = continent,
#'     children = lapply(dat[[continent]][["countryName"]], function(cntry){
#'       list(
#'         text = cntry,
#'         data = list(population = Countries[cntry, "population"])
#'       )
#'     })
#'   )
#' })
#'
#' onrender <- c(
#'   "function(el, x) {",
#'   "  Shiny.addCustomMessageHandler('hideNodes', function(range) {",
#'   "    var tree = $.jstree.reference(el.id);",
#'   "    var json = tree.get_json(null, {flat: true});",
#'   "    for(var i = 0; i < json.length; i++) {",
#'   "      var id = json[i].id;",
#'   "      if(tree.is_leaf(id)) {",
#'   "        var pop = json[i].data.population;",
#'   "        if(pop < range[0] || pop > range[1]) {",
#'   "          tree.hide_node(id);",
#'   "        } else {",
#'   "          tree.show_node(id);",
#'   "        }",
#'   "      }",
#'   "    }",
#'   "  });",
#'   "}"
#' )
#'
#' ui <- fluidPage(
#'   tags$h3("Open a node and filter with the slider."),
#'   br(),
#'   fluidRow(
#'     column(
#'       6,
#'       jstreeOutput("tree")
#'     ),
#'     column(
#'       6,
#'       sliderInput(
#'         "range",
#'         label = "Population",
#'         min = 0, max = 100000000, value = c(0, 100000000)
#'       )
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session){
#'
#'   output[["tree"]] <- renderJstree({
#'     jstree(nodes, checkboxes = TRUE) %>% onRender(onrender)
#'   })
#'
#'   observeEvent(input[["range"]], {
#'     session$sendCustomMessage("hideNodes", input[["range"]])
#'   })
#'
#' }
#'
#' if(interactive()){
#'   shinyApp(ui, server)
#' }
#'
#'
#' # Filtering - grid ####
#' library(jsTreeR)
#' library(shiny)
#' library(htmlwidgets)
#' library(magrittr)
#'
#' data("Countries")
#' rownames(Countries) <- Countries[["countryName"]]
#' dat <- split(Countries, Countries[["continentName"]])
#' nodes <- lapply(names(dat), function(continent){
#'   list(
#'     text = continent,
#'     children = lapply(dat[[continent]][["countryName"]], function(cntry){
#'       list(
#'         text = cntry,
#'         data = list(
#'           countrycode = Countries[cntry, "countryCode"],
#'           capital = Countries[cntry, "capital"],
#'           population = Countries[cntry, "population"]
#'         )
#'       )
#'     })
#'   )
#' })
#' grid <- list(
#'   columns = list(
#'     list(
#'       width = 430,
#'       header = "Country",
#'       headerClass = "yellow"
#'     ),
#'     list(
#'       width = 150,
#'       value = "capital",
#'       header = "Capital",
#'       wideCellClass = "lightorange",
#'       headerClass = "yellow"
#'     ),
#'     list(
#'       width = 110,
#'       value = "countrycode",
#'       header = "Country code",
#'       wideCellClass = "centered lightgreen",
#'       headerClass = "yellow"
#'     ),
#'     list(
#'       width = 150,
#'       value = "population",
#'       header = "Population",
#'       wideCellClass = "lightorange",
#'       headerClass = "yellow"
#'     )
#'   ),
#'   width = 850
#' )
#' onrender <- c(
#'   "function(el, x) {",
#'   "  Shiny.addCustomMessageHandler('hideNodes', function(range) {",
#'   "    var tree = $.jstree.reference(el.id);",
#'   "    var json = tree.get_json(null, {flat: true});",
#'   "    for(var i = 0; i < json.length; i++) {",
#'   "      var id = json[i].id;",
#'   "      if(tree.is_leaf(id)) {",
#'   "        var pop = json[i].data.population;",
#'   "        if(pop < range[0] || pop > range[1]) {",
#'   "          tree.hide_node(id);",
#'   "        } else {",
#'   "          tree.show_node(id);",
#'   "        }",
#'   "      }",
#'   "    }",
#'   "  });",
#'   "}"
#' )
#'
#' ui <- fluidPage(
#'   tags$head(
#'     tags$style(
#'       HTML(c(
#'         ".lightorange {background-color: #fed8b1;}",
#'         ".lightgreen {background-color: #98ff98;}",
#'         "#tree {background-color: #98ff98;}",
#'         ".jstree-container-ul>li>a {",
#'         "  font-weight: bold; font-style: italic; font-size: large;",
#'         "}",
#'         ".yellow {background-color: yellow !important;}",
#'         ".centered {text-align: center;}",
#'         ".jstree-children>li>a {",
#'         "  font-weight: 700; font-family: Helvetica; font-size: larger;",
#'         "}"
#'       ))
#'     )
#'   ),
#'   tags$h3("Open a node and filter with the slider."),
#'   br(),
#'   sliderInput(
#'     "range",
#'     label = "Population",
#'     min = 0, max = 100000000, value = c(0, 100000000),
#'     width = "850px"
#'   ),
#'   br(),
#'   jstreeOutput("tree")
#' )
#'
#' server <- function(input, output, session){
#'
#'   output[["tree"]] <- renderJstree({
#'     jstree(nodes, grid = grid, checkboxes = TRUE) %>%
#'       onRender(onrender)
#'   })
#'
#'   observeEvent(input[["range"]], {
#'     session$sendCustomMessage("hideNodes", input[["range"]])
#'   })
#'
#' }
#'
#' if(interactive()){
#'   shinyApp(ui, server)
#' }
jstreeOutput <- function(outputId, width = "100%", height = "auto"){
  htmlwidgets::shinyWidgetOutput(
    outputId, 'jstreer', width, height, package = 'jsTreeR'
  )
}

#' @rdname jstree-shiny
#' @export
renderJstree <- function(expr, env = parent.frame(), quoted = FALSE) {
  if(!quoted) expr <- substitute(expr) # force quoted
  htmlwidgets::shinyRenderWidget(expr, jstreeOutput, env, quoted = TRUE)
}