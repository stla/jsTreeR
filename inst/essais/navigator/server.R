shinyServer(function(input, output, session){

  output$navigator <- renderJstree({
    jstree(
      nodes = list(
        list(
          text = "C:/SL/MyPackages",
          type = "folder",
          children = FALSE,
          li_attr = list(
            class = "jstree-x"
          )
          # children = list(
          #   list(
          #     text = "xxx",
          #     type = "file"
          #   )
          # )
        )
      ),
      types = list(
        folder = list(
          icon = "fa fa-folder gold"
        ),
        file = list(
          icon = "far fa-file red"
        )
      ),
      checkCallback = TRUE,
      theme = "default",
      checkboxes = TRUE,
      search = TRUE
    ) %>% onRender('function(el, x){if(tree === null) tree = $(el).jstree(true);}')
  })

  observeEvent(input$path, {
    cat("path: ")
    print(input$path)
    lf <- list.files(input$path, full.names = TRUE)
    if(input$path == "C:/SL/MyPackages"){
      lf <- lf[sort(sample.int(15))]
    }
    fi <- file.info(lf, extra_cols = FALSE)
    x <- list(
      elem = as.list(basename(lf)),
      folder = as.list(fi$isdir)
    )
    session$sendCustomMessage("getChildren", x)
  })

})
