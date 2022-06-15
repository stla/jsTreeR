shinyServer(
  function(input, output, session){

    output[["mytree"]] <- renderJstree({
      jstree(nodes)
    })

  }
)
