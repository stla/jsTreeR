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

isBoolean <- function(x){
  is.logical(x) && (length(x) == 1L) && !is.na(x)
}

isString <- function(x){
  is.character(x) && (length(x) == 1L) && !is.na(x)
}

isNamedList <- function(x){
  is.list(x) && !is.null(names(x)) && all(names(x) != "")
}

isUnnamedList <- function(x){
  is.list(x) && is.null(names(x))
}

isNodesList <- function(nodes){
  isUnnamedList(nodes) &&
    all(vapply(nodes, function(node){
      isNamedList(node) && "text" %in% names(node)
    }, logical(1L)))
}

isJS <- function(x){
  inherits(x, "JS_EVAL")
}

isCallbackNodes <- function(nodes){
  isJS(nodes)
}

isAJAXnodes <- function(nodes){
  isNamedList(nodes) && "url" %in% names(nodes)
}

isLAZYnodes <- function(nodes){
  isNamedList(nodes) && all(c("url", "data") %in% names(nodes)) &&
    grepl("lazy", nodes[["url"]])
}
