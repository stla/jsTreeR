shinyServer(function(input, output, session){

  Paths <- treeNavigatorServer(
    "explorer", rootFolder = rootFolder,
    search = list( # (search in the visited folders only)
      show_only_matches  = TRUE,
      case_sensitive     = TRUE,
      search_leaves_only = TRUE
    ),
    contextMenu = list(items = menuItems, select_node = FALSE)
  )

  observeEvent(input[["path"]], {
    mode <- aceMode(input[["path"]])
    if(is.null(mode)){
      showModal(modalDialog(
        "Cannot open this file!",
        title = "Binary file",
        footer = NULL,
        easyClose = TRUE
      ))
    }else{
      contents <- paste0(suppressWarnings(
        readLines(input[["path"]])
      ), collapse = "\n")
      showModal(modalDialog(
        aceEditor(
          "aceEditor",
          value = contents,
          mode = mode,
          theme = "cobalt",
          tabSize = 2,
          height = "60vh"
        ),
        size = "l"
      ))
    }
  })

})
