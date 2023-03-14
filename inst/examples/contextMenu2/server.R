shinyServer(
  function(input, output, session){
    output[["mytree"]] <- renderJstree({
      jstree(
        nodes,
        checkCallback = TRUE,
        contextMenu = list(items = customMenu),
        types = list(
          "unalterable" = list(icon = "fa-solid fa-leaf"),
          "parent"      = list(icon = "fa-brands fa-pagelines")
        ),
        theme = "proton"
      )
    })
  }
)
