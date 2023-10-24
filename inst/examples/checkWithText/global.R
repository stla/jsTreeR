library(jsTreeR)
library(shiny)

# small function to shorten the Shiny values
Text <- function(value) {
  lapply(value, `[[`, "text")
}

# CSS for the second tree (the one with `checkWithText=FALSE`)
css <- "
#tree2 .jstree-clicked:not(.jstree-checked) {
  background-color: tomato !important;
}"

# nodes list for both trees
nodes <- list(
  list(
    text = "RootA",
    children = list(
      list(
        text = "ChildA1"
      ),
      list(
        text = "ChildA2"
      )
    )
  ),
  list(
    text = "RootB",
    children = list(
      list(
        text = "ChildB1"
      ),
      list(
        text = "ChildB2"
      )
    )
  )
)
