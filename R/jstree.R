`%||%` <- function(x, y){
  if(is.null(x)) y else x
}


#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
jstree <- function(
  data, width = NULL, height = NULL, elementId = NULL,
  checkbox = FALSE,
  search = FALSE, searchtime = 250,
  dragAndDrop = FALSE,
  types = NULL,
  sort = FALSE,
  unique = FALSE,
  wholerow = FALSE,
  contextMenu = FALSE,
  checkCallback = NULL
){

  # forward options using x
  x = list(
    data = data,
    checkbox = checkbox,
    search = search,
    searchtime = searchtime,
    dragAndDrop = dragAndDrop,
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
    width = width,
    height = height,
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
