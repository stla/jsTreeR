shinyServer(
  function(input, output){

    output[["jstree"]] <- renderJstree({
      jstree(
        nodes, dragAndDrop = TRUE, checkboxes = TRUE, theme = "proton",
        selectLeavesOnly = TRUE
      )
    })

    output[["treeState"]] <- renderPrint({
      toJSON(input[["jstree"]], pretty = TRUE, auto_unbox = TRUE)
    })

    output[["treeSelected"]] <- renderPrint({
      toJSON(input[["jstree_selected"]], pretty = TRUE, auto_unbox = TRUE)
    })

  }
)
