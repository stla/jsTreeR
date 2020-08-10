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
#'       a named list defining the state of the node XXXXXXXXXXXXXXXXXXXXX
#'     }
#'   }
#' @param elementId a HTML id for the widget (useless for common usage)
#' @param checkboxes logical, whether to enable checkboxes next to each node;
#'   this makes easier the selection of multiple nodes
#' @param search logical, whether to enable the search functionality
#' @param searchtime currently ignored
#' @param dragAndDrop logical, whether to allow the rearrangement of the nodes
#'   by dragging and dropping
#' @param dnd a named list of options related to the drag-and-drop
#'   functionality, e.g. the \code{is_draggable} function to define which nodes
#'   are draggable; see the first example and the
#'   \href{https://www.jstree.com/api/}{jsTree API documentation} for the list
#'   of possible options
#' @param types a named list of node properties; see first example
#' @param sort logical, whether to sort the nodes
#' @param unique logical, whether to ensure that no node label is duplicated
#' @param wholerow logical, whether to highlight whole selected rows
#' @param contextMenu logical, whether to enable a context menu to create,
#'   rename, delete, cut, copy and paste nodes
#' @param checkCallback a JavaScript function; see the example where it is used
#'   to define restrictions on the drag-and-drop behavior
#' @param grid list of settings for the grid; see the second example and
#'   \href{https://github.com/deitch/jstree-grid/#options}{github.com/deitch/jstree-grid}
#'   for the list of all available options
#' @param theme jsTree theme, one of default, default-dark, or proton.
#'
#' @import htmlwidgets
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
    dependencies = htmltools::htmlDependency(
      name = "bootstrap",
      version = "3.4.1",
      src = "www/shared/bootstrap",
      stylesheet = "css/bootstrap.min.css",
      package = "shiny"
    )
  )
}

#' Shiny bindings for jstree
#'
#' Output and render functions for using jstree within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a jstree
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name jstree-shiny
#'
#' @export
jstreeOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'jstree', width, height, package = 'jsTreeR')
}

#' @rdname jstree-shiny
#' @export
renderJstree <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, jstreeOutput, env, quoted = TRUE)
}
