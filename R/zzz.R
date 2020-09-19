#' @importFrom shiny registerInputHandler addResourcePath
#' @noRd
.onAttach <- function(libname, pkgname){
  shiny::registerInputHandler("jsTreeR.list", function(data, ...){
    data
  }, force = TRUE)
  shiny::registerInputHandler("jsTreeR.move", function(data, ...){
    lapply(data, unlist)
  }, force = TRUE)
  shiny::addResourcePath(
    "SuperTinyIcons",
    system.file("htmlwidgets", "SuperTinyIcons", package = "jsTreeR")
  )
  shiny::addResourcePath(
    "OtherIcons",
    system.file("htmlwidgets", "OtherIcons", package = "jsTreeR")
  )
}

#' @importFrom shiny removeResourcePath
#' @noRd
.onDetach <- function(libpath){
  shiny::removeResourcePath("SuperTinyIcons")
  shiny::removeResourcePath("OtherIcons")
}
