library(jsTreeR)
library(shiny)
library(jsonlite)

nodes <- fromJSON(
  system.file(
    "www", "SuperTinyIcons", "SuperTinyIcons.json", package = "jsTreeR"
  ),
  simplifyDataFrame = FALSE
)

css <- HTML("
  .flexcol {
    display: flex;
    flex-direction: column;
    width: 100%;
    margin: 0;
  }
  .stretch {
    flex-grow: 1;
    height: 1px;
  }
  .bottomright {
    position: fixed;
    bottom: 0;
    right: 15px;
    min-width: calc(50% - 15px);
  }
  #jstree {
    background-color: #fff5ee;
  }
  img {
    background-color: #555;
    padding: 50px;
  }
")
