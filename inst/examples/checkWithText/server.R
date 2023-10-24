shinyServer(
  function(input, output, session){

    output[["tree1"]] <- renderJstree({
      jstree(
        nodes, checkboxes = TRUE, dragAndDrop = TRUE
      )
    })

    output[["tree2"]] <- renderJstree({
      jstree(
        nodes, checkboxes = TRUE, checkWithText = FALSE, dragAndDrop = TRUE
      )
    })

    output[["checked1"]] <- renderPrint({
      input[["tree1_checked"]] |> Text()
    })

    output[["checked2"]] <- renderPrint({
      input[["tree2_checked"]] |> Text()
    })

    output[["selected1"]] <- renderPrint({
      input[["tree1_selected"]] |> Text()
    })

    output[["selected2"]] <- renderPrint({
      input[["tree2_selected"]] |> Text()
    })

  }
)
