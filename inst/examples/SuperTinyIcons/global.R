library(jsTreeR)
library(shiny)
library(jsonlite)

nodes <- fromJSON(
  system.file(
    "htmlwidgets", "SuperTinyIcons", "SuperTinyIcons.json", package = "jsTreeR"
  ),
  simplifyDataFrame = FALSE
)
