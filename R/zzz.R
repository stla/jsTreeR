#' @importFrom shiny registerInputHandler addResourcePath
#' @importFrom jsonlite fromJSON toJSON
#' @noRd
.onAttach <- function(libname, pkgname){
  shiny::registerInputHandler("jsTreeR.list", function(data, ...){
    jsonlite::fromJSON(
      jsonlite::toJSON(data, auto_unbox = TRUE),
      simplifyDataFrame = FALSE
    )
  }, force = TRUE)
  shiny::addResourcePath(
    "SuperTinyIcons",
    system.file("htmlwidgets", "SuperTinyIcons", package = "jsTreeR")
  )
}

#' @importFrom shiny removeResourcePath
#' @noRd
.onDetach <- function(libpath){
  shiny::removeResourcePath("SuperTinyIcons")
}
