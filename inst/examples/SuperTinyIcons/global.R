library(jsTreeR)
library(shiny)
library(jsonlite)

nodes <- fromJSON(
  system.file(
    "www", "SuperTinyIcons", "SuperTinyIcons.json", package = "jsTreeR"
  ),
  simplifyDataFrame = FALSE
)
