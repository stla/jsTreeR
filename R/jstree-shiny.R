#' @title Shiny bindings for jstree
#'
#' @description Output and render functions for using \code{jstree} within
#'   Shiny applications and interactive Rmd documents. See examples with
#'   \code{\link{jstreeExample}}.
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
#' @return \code{jstreeOutput} returns an output element that can be included
#'   in a Shiny UI definition, and \code{renderJstree} returns a
#'   \code{shiny.render.function} object that can be included in a Shiny server
#'   definition.
#'
#' @name jstree-shiny
#'
#' @importFrom htmlwidgets shinyWidgetOutput shinyRenderWidget
#' @export
jstreeOutput <- function(outputId, width = "100%", height = "auto"){
  shinyWidgetOutput(
    outputId, 'jstreer', width, height, package = 'jsTreeR'
  )
}

#' @rdname jstree-shiny
#' @export
renderJstree <- function(expr, env = parent.frame(), quoted = FALSE) {
  if(!quoted) expr <- substitute(expr) # force quoted
  shinyRenderWidget(expr, jstreeOutput, env, quoted = TRUE)
}
