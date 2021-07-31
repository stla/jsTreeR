shinyServer(
  function(input, output){

    output[["jstree"]] <-
      renderJstree(
        jstree(
          nodes, search = TRUE, checkboxes = TRUE,
          selectLeavesOnly = input[["leavesOnly"]]
        )
      )

    output[["treeSelected_json"]] <- renderPrint({
      toJSON(input[["jstree_selected"]], pretty = TRUE, auto_unbox = TRUE)
    })

    output[["treeSelected_R"]] <- renderPrint({
      input[["jstree_selected"]]
    })

  }
)
