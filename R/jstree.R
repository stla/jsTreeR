#' Objects imported from other packages
#' @description These objects are imported from other packages.
#'   Follow the links to their documentation:
#'   \code{\link[htmlwidgets:JS]{JS}},
#'   \code{\link[htmlwidgets:saveWidget]{saveWidget}}.
#' @importFrom htmlwidgets JS saveWidget
#' @export JS saveWidget
#' @name jsTreeR-imports
#' @aliases JS saveWidget
#' @docType import
NULL


`%||%` <- function(x, y){
  if(is.null(x)) y else x
}


#' HTML widget displaying an interactive tree
#' @description Create a HTML widget displaying an interactive tree.
#'
#' @param nodes data, a list of nodes; each node is a list with a required
#'   field \code{text}, a character string labeling the node, and optional
#'   fields
#'   \describe{
#'     \item{\code{children}}{
#'       a list of nodes
#'     }
#'     \item{\code{data}}{
#'       a named list of data to attach to the node; see the
#'       \link[jsTreeR:jstreeOutput]{Shiny examples}
#'     }
#'     \item{\code{icon}}{
#'       space-separated HTML class names defining an icon, e.g.
#'       \code{"glyphicon glyphicon-flash"}; in a Shiny app you can also use
#'       a super tiny icon, e.g. \code{"supertinyicon-julia"}; see the
#'       \link[jsTreeR:jstreeOutput]{Shiny example} showing all available such
#'       icons
#'     }
#'     \item{\code{type}}{
#'       a character string for usage with the \code{types} option; see first
#'       example
#'     }
#'     \item{\code{state}}{
#'       a named list defining the state of the node, with four possible fields,
#'       each being \code{TRUE} or \code{FALSE}:
#'       \describe{
#'         \item{\code{opened}}{
#'           whether the node should be initially opened
#'         }
#'         \item{\code{selected}}{
#'           whether the node should be initially selected
#'         }
#'         \item{\code{disabled}}{
#'           whether the node should be disabled
#'         }
#'         \item{\code{checked}}{
#'           whether the node should be initially checked, effective
#'           only when the \code{checkboxes} option is \code{TRUE}
#'         }
#'       }
#'     }
#'     \item{\code{a_attr}}{
#'       a named list of attributes for the node label, such as
#'       \code{list(title = "I'm a tooltip", style = "color: red;")}
#'     }
#'     \item{\code{li_attr}}{
#'       a named list of attributes for the whole node, including its children,
#'       such as
#'       \code{list(title = "I'm a tooltip", style = "background-color: pink;")}
#'     }
#'   }
#' @param elementId a HTML id for the widget (useless for common usage)
#' @param checkboxes logical, whether to enable checkboxes next to each node;
#'   this makes easier the selection of multiple nodes
#' @param search either a logical value, whether to enable the search
#'   functionality with default options, or a named list of options for the
#'   search functionality; see the \link[jsTreeR:jstreeOutput]{Shiny example}
#'   and the \href{https://www.jstree.com/api/}{jsTree API documentation} for
#'   the list of possible options
#' @param searchtime currently ignored
#' @param dragAndDrop logical, whether to allow the rearrangement of the nodes
#'   by dragging and dropping
#' @param dnd a named list of options related to the drag-and-drop
#'   functionality, e.g. the \code{is_draggable} function to define which nodes
#'   are draggable; see the first example and the
#'   \href{https://www.jstree.com/api/}{jsTree API documentation} for the list
#'   of possible options
#' @param multiple logical, whether to allow multiselection
#' @param types a named list of node properties; see first example
#' @param sort logical, whether to sort the nodes
#' @param unique logical, whether to ensure that no node label is duplicated
#' @param wholerow logical, whether to highlight whole selected rows
#' @param contextMenu either a logical value, whether to enable a context menu
#'   to create/rename/delete/cut/copy/paste nodes, or a list of options; see
#'   the \href{https://www.jstree.com/api/}{jsTree API documentation} for the
#'   possible options
#' @param checkCallback either \code{TRUE} to allow to perform some actions
#'   such as creating a new node, or a JavaScript function; see the example
#'   where this option is used to define restrictions on the drag-and-drop
#'   behavior
#' @param grid list of settings for the grid; see the second example, the
#'   \link[jsTreeR:jstreeOutput]{Shiny example}, and
#'   \href{https://github.com/deitch/jstree-grid/#options}{github.com/deitch/jstree-grid}
#'   for the list of all available options
#' @param theme jsTree theme, one of \code{"default"},
#'   \code{"default-dark"}, or \code{"proton"}
#'
#' @import htmlwidgets
#' @importFrom htmltools htmlDependency
#' @export
#'
#' @examples # example illustrating the 'dnd' and 'checkCallback' options ####
#'
#' library(jsTreeR)
#'
#' nodes <- list(
#'   list(
#'     text = "RootA",
#'     type = "root",
#'     children = list(
#'       list(
#'         text = "ChildA1",
#'         type = "child"
#'       ),
#'       list(
#'         text = "ChildA2",
#'         type = "child"
#'       )
#'     )
#'   ),
#'   list(
#'     text = "RootB",
#'     type = "root",
#'     children = list(
#'       list(
#'         text = "ChildB1",
#'         type = "child"
#'       ),
#'       list(
#'         text = "ChildB2",
#'         type = "child"
#'       )
#'     )
#'   )
#' )
#'
#' types <- list(
#'   root = list(
#'     icon = "glyphicon glyphicon-ok"
#'   ),
#'   child = list(
#'     icon = "glyphicon glyphicon-file"
#'   )
#' )
#'
#' checkCallback <- JS(
#'   "function(operation, node, parent, position, more) {",
#'   "  if(operation === 'move_node') {",
#'   "    if(parent.id === '#' || parent.type === 'child') {",
#'   "      return false;", # prevent moving a child above or below the root
#'   "    }",               # and moving inside a child
#'   "  }",
#'   "  return true;", # allow everything else
#'   "}"
#' )
#'
#' dnd <- list(
#'   is_draggable = JS(
#'     "function(node) {",
#'     "  return node[0].type === 'child';",
#'     "}"
#'   )
#' )
#'
#' jstree(
#'   nodes,
#'   dragAndDrop = TRUE, dnd = dnd,
#'   types = types,
#'   checkCallback = checkCallback
#' )
#'
#'
#' # example illustrating the 'grid' option ####
#'
#' library(jsTreeR)
#'
#' nodes <- list(
#'   list(
#'     text = "Products",
#'     children = list(
#'       list(
#'         text = "Fruit",
#'         children = list(
#'           list(
#'             text = "Apple",
#'             data = list(
#'               price = 0.1,
#'               quantity = 20
#'             )
#'           ),
#'           list(
#'             text = "Banana",
#'             data = list(
#'               price = 0.2,
#'               quantity = 31
#'             )
#'           ),
#'           list(
#'             text = "Grapes",
#'             data = list(
#'               price = 1.99,
#'               quantity = 34
#'             )
#'           ),
#'           list(
#'             text = "Mango",
#'             data = list(
#'               price = 0.5,
#'               quantity = 8
#'             )
#'           ),
#'           list(
#'             text = "Melon",
#'             data = list(
#'               price = 0.8,
#'               quantity = 4
#'             )
#'           ),
#'           list(
#'             text = "Pear",
#'             data = list(
#'               price = 0.1,
#'               quantity = 30
#'             )
#'           ),
#'           list(
#'             text = "Strawberry",
#'             data = list(
#'               price = 0.15,
#'               quantity = 32
#'             )
#'           )
#'         ),
#'         state = list(
#'           opened = TRUE
#'         )
#'       ),
#'       list(
#'         text = "Vegetables",
#'         children = list(
#'           list(
#'             text = "Aubergine",
#'             data = list(
#'               price = 0.5,
#'               quantity = 8
#'             )
#'           ),
#'           list(
#'             text = "Broccoli",
#'             data = list(
#'               price = 0.4,
#'               quantity = 22
#'             )
#'           ),
#'           list(
#'             text = "Carrot",
#'             data = list(
#'               price = 0.1,
#'               quantity = 32
#'             )
#'           ),
#'           list(
#'             text = "Cauliflower",
#'             data = list(
#'               price = 0.45,
#'               quantity = 18
#'             )
#'           ),
#'           list(
#'             text = "Potato",
#'             data = list(
#'               price = 0.2,
#'               quantity = 38
#'             )
#'           )
#'         )
#'       )
#'     ),
#'     state = list(
#'       opened = TRUE
#'     )
#'   )
#' )
#'
#' grid <- list(
#'   columns = list(
#'     list(
#'       width = 200,
#'       header = "Name"
#'     ),
#'     list(
#'       width = 150,
#'       value = "price",
#'       header = "Price"
#'     ),
#'     list(
#'       width = 150,
#'       value = "quantity",
#'       header = "Qty"
#'     )
#'   ),
#'   width = 600
#' )
#'
#' jstree(nodes, grid = grid)
jstree <- function(
  nodes, elementId = NULL,
  checkboxes = FALSE,
  search = FALSE, searchtime = 250,
  dragAndDrop = FALSE, dnd = NULL,
  multiple = TRUE,
  types = NULL,
  sort = FALSE,
  unique = FALSE,
  wholerow = FALSE,
  contextMenu = FALSE,
  checkCallback = NULL,
  grid = NULL,
  theme = "default"
){
  # forward options using x
  x = list(
    data = nodes,
    checkbox = checkboxes,
    search = search,
    searchtime = searchtime,
    dragAndDrop = dragAndDrop,
    dnd = dnd,
    multiple = multiple,
    types = types,
    sort = sort,
    unique = unique,
    wholerow = wholerow,
    contextMenu = contextMenu,
    checkCallback = checkCallback %||% (dragAndDrop || contextMenu),
    grid = grid,
    theme = match.arg(theme, c("default", "default-dark", "proton"))
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'jstree',
    x,
    width = NULL,
    height = NULL,
    package = 'jsTreeR',
    elementId = elementId,
    dependencies = list(
      htmltools::htmlDependency(
        name = "bootstrap",
        version = "3.4.1",
        src = "www/shared/bootstrap",
        stylesheet = "css/bootstrap.min.css",
        package = "shiny"
      ),
      htmltools::htmlDependency(
        name = "fontawesome",
        version = "5.13.0",
        src = "www/shared/fontawesome",
        stylesheet = "css/all.min.css",
        package = "shiny"
      )
    )
  )
}

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
jstreeOutput <- function(outputId, width = "100%", height = "auto"){
  htmlwidgets::shinyWidgetOutput(
    outputId, 'jstree', width, height, package = 'jsTreeR'
  )
}

#' @rdname jstree-shiny
#' @export
renderJstree <- function(expr, env = parent.frame(), quoted = FALSE) {
  if(!quoted) expr <- substitute(expr) # force quoted
  htmlwidgets::shinyRenderWidget(expr, jstreeOutput, env, quoted = TRUE)
}
