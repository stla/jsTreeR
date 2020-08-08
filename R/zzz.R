#' @importFrom shiny registerInputHandler
#' @importFrom jsonlite fromJSON toJSON
#' @noRd
.onAttach <- function(libname, pnkgname){
  shiny::registerInputHandler("jsTreeR.list", function(data, ...){
    jsonlite::fromJSON(
      jsonlite::toJSON(data, auto_unbox = TRUE),
      simplifyDataFrame = FALSE
    )
  }, force = TRUE)
}
