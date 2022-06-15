#' @importFrom shiny registerInputHandler
#' @noRd
.onAttach <- function(libname, pkgname){
  shiny::registerInputHandler("jsTreeR.list", function(data, ...){
    data
  }, force = TRUE)
  shiny::registerInputHandler("jsTreeR.move", function(data, ...){
    lapply(data, unlist)
  }, force = TRUE)
  shiny::registerInputHandler("jsTreeR.copied", function(data, ...){
    data[["from"]][["path"]] <- unlist(data[["from"]][["path"]])
    data[["to"]][["path"]] <- unlist(data[["to"]][["path"]])
    data
  }, force = TRUE)
  shiny::registerInputHandler("jsTreeR.path", function(data, ...){
    data[["path"]] <- unlist(data[["path"]])
    data
  }, force = TRUE)
}
