shinyServer(
  function(input, output, session){

    output[["mytree"]] <- renderJstree({
      jstree(nodes, multiple = FALSE, wholerow = TRUE)
    })

    output[["png"]] <- renderUI({
      req(length(input[["mytree_selected"]]) > 0)
      png <- input[["mytree_selected"]][[1]][["data"]][["png"]]
      tags$img(src = png, width = "55%")
    })

  }
)
