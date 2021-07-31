shinyServer(
  function(input, output, session){

    output[["tree"]] <- renderJstree({
      jstree(nodes, checkboxes = TRUE) %>% onRender(onrender)
    })

    observeEvent(input[["range"]], {
      session$sendCustomMessage("hideNodes", input[["range"]])
    })

  }
)
