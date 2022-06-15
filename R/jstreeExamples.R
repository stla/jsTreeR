#' @title jsTreeR examples
#' @description List of Shiny examples.
#'
#' @return No returned value, just prints a message listing the example names.
#'
#' @export
#'
#' @examples
#' jstreeExamples()
#' if(interactive()){
#'   jstreeExample("grid")
#' }
jstreeExamples <- function(){
  Folder <- system.file("examples", package = "jsTreeR")
  Examples <- list.dirs(Folder, full.names = FALSE, recursive = FALSE)
  message("jsTreeR examples: ", toString(Examples), ".")
  message('Type `jstreeExample("ExampleName")` to run an example.')
}

#' @title Run a Shiny jsTreeR example
#' @description A function to run examples of Shiny apps using the
#'   \code{jsTreeR} package.
#'
#' @param example example name
#' @param display.mode the display mode to use when running the example; see
#'   \code{\link[shiny:runApp]{runApp}}
#' @param ... arguments passed to \code{\link[shiny:runApp]{runApp}}
#'
#' @return No return value, just launches a Shiny app.
#'
#' @export
#' @importFrom shiny runApp
#'
#' @examples
#' if(interactive()){
#'   jstreeExample("folder")
#' }
#' if(interactive()){
#'   jstreeExample("fontawesome")
#' }
#' if(interactive()){
#'   jstreeExample("SuperTinyIcons")
#' }
#' if(interactive()){
#'   jstreeExample("filtering")
#' }
#' if(interactive()){
#'   jstreeExample("grid")
#' }
#' if(interactive()){
#'   jstreeExample("gridFiltering")
#' }
#' if(interactive()){
#'   jstreeExample("treeNavigator")
#' }
#' if(interactive()){
#'   jstreeExample("imageIcon")
#' }
jstreeExample <- function(example, display.mode = "showcase", ...) {
  Folder <- system.file("examples", package = "jsTreeR")
  Examples <- list.dirs(Folder, full.names = FALSE, recursive = FALSE)
  if(example %in% Examples){
    appname <- normalizePath(file.path(Folder, example))
    runApp(appname, display.mode = display.mode, ...)
  }else{
    stop(
      "Could not find example: '", example, "'.",
      "\nAvailable examples are: ", paste0(Examples, collapse = ", "), "."
    )
  }
}
