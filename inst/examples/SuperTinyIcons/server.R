shinyServer(
  function(input, output){
    output[["jstree"]] <- renderJstree({
      jstree(nodes, multiple = FALSE, search = list(
        show_only_matches = TRUE,
        case_sensitive = TRUE,
        search_leaves_only = TRUE
      ))
    })
    output[["icon"]] <- renderUI({
      req(length(input[["jstree_selected"]]) > 0)
      svg <- req(input[["jstree_selected"]][[1]][["data"]][["svg"]])
      if(input[["transparent"]])
        svg <- paste0("transparent-", svg)
      tags$img(src = paste0("/SuperTinyIcons/", svg), width = "75%")
    })
  }
)
