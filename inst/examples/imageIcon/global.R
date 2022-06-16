library(jsTreeR)
library(shiny)

css <- "
i.jstree-themeicon-custom {
  background-size: contain !important;
}
"

nodes <- list(
  list(
    text = "Dupin cyclide",
    icon = "/cyclide.png",
    data = list(
      png = "cyclide.png"
    )
  ),
  list(
    text = "Hopf torus",
    icon = "/hopftorus.png",
    data = list(
      png = "hopftorus.png"
    )
  )
)

