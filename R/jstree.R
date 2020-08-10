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
#'       a SuperTinyIcon, e.g. \code{"supertinyicon-julia"}; see the
#'       \link[jsTreeR:jstreeOutput]{Shiny example} showing all available such
#'       icons
#'     }
#'     \item{\code{type}}{
#'       a character string for usage with the \code{types} option; see example
#'     }
#'   }
#' @param elementId a HTML id for the widget (useless for common usage)
#' @param checkboxes logical, whether to enable checkboxes next to each node;
#'   this makes easier the selection of multiple nodes
#' @param search logical, whether to enable the search functionality
#' @param searchtime currently ignored
#' @param dragAndDrop logical, whether to allow the rearrangement of the nodes
#'   by dragging and dropping
#' @param dnd a named list of JavaScript functions related to the drag-and-drop
#'   functionality, e.g. the \code{is_draggable} function to define which nodes
#'   are draggable; see the example and the
#'   \href{https://www.jstree.com/api/}{jsTree API documentation} for the list
#'   of possible functions
#' @param types a named list of node properties; see example
#' @param sort logical, whether to sort the nodes
#' @param unique logical, whether to ensure that no node label is duplicated
#' @param wholerow logical, whether to highlight whole selected rows
#' @param contextMenu logical, whether to enable a context menu to create,
#'   rename, delete, cut, copy and paste nodes
#' @param checkCallback a JavaScript function; see the example where it is used
#'   to define restrictions on the drag-and-drop behavior
#'
#' @import htmlwidgets
#'
#' @export
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
  checkCallback = NULL
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
    checkCallback = checkCallback %||% (dragAndDrop || contextMenu)
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
