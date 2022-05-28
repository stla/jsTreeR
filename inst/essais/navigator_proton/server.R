shinyServer(function(input, output, session){

  shinyDirChoose(
    input, "rootfolder", roots = roots,
    allowDirCreate = FALSE, defaultRoot = "wd"
  )

  RootFolder <- eventReactive(input[["rootfolder"]], {
    parseDirPath(roots, input[["rootfolder"]])
  })

  output[["choice"]] <- reactive({
    isTruthy(RootFolder())
  })
  outputOptions(output, "choice", suspendWhenHidden = FALSE)

  output[["navigator"]] <- renderJstree({
    req(isTruthy(RootFolder()))
    jstree(
      nodes = list(
        list(
          text = RootFolder(),
          type = "folder",
          children = FALSE,
          li_attr = list(
            class = "jstree-x"
          )
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
      theme = "proton",
      checkboxes = TRUE,
      search = TRUE,
      selectLeavesOnly = TRUE
    )
  })

  observeEvent(input[["path"]], {
    lf <- list.files(input[["path"]], full.names = TRUE)
    fi <- file.info(lf, extra_cols = FALSE)
    x <- list(
      elem = as.list(basename(lf)),
      folder = as.list(fi[["isdir"]])
    )
    session$sendCustomMessage("getChildren", x)
  })

  Paths <- reactive({
    vapply(
      input[["navigator_selected_paths"]], `[[`,
      character(1L), "path"
    )
  })

  output[["selections"]] <- renderPrint({
    cat(Paths(), sep = "\n")
  })

  output[["dwnld"]] <- downloadHandler(
    filename = "myfiles.zip",
    content = function(file){
      zip(file, files = Paths())
    }
  )

})
