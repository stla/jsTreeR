shinyServer(
  function(input, output, session){

    output[["tree1"]] <- renderJstree({
      jstree(nodes, checkboxes = TRUE)
    })

    output[["tree2"]] <- renderJstree({
      jstree(nodes, checkboxes = TRUE, checkWithText = FALSE)
    })

  }
)
