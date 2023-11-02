#' @importFrom htmltools validateCssUnit
#' @noRd
validateGrid <- function(grid) {
  if(is.null(grid)) {
    return(NULL)
  }
  columns <- grid[["columns"]]
  for(i in seq_along(columns)) {
    column <- columns[[i]]
    width <- column[["width"]]
    if(is.null(width)) {
      width <- "auto"
    } else {
      width <- validateCssUnit(width)
    }
    column[["width"]] <- width
    columns[[i]] <- column
  }
  grid[["columns"]] <- columns
  grid
}
