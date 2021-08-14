shinyServer(
  function(input, output, session){

    output[["mytree"]] <- renderJstree({
      jstree(
        nodes, checkCallback = TRUE,
        contextMenu = list(items = customMenu)
      )
    })

  }
)
