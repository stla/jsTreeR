list.files_and_dirs <- function(path, pattern, all.files){
  lfs <- list.files(
    path, pattern = pattern, all.files = all.files, full.names = TRUE
  )
  if(is.null(pattern)){
    lfs
  }else{
    lds <- list.dirs(path, full.names = TRUE, recursive = FALSE)
    sort(union(lfs, lds))
  }
}

#' @importFrom htmltools htmlDependency
#' @importFrom utils packageVersion
#' @noRd
treeNavigatorDep <- function(){
  htmlDependency(
    name = "treeNavigator",
    version = as.character(packageVersion("jsTreeR")),
    src = "www",
    script = "treeNavigator.js",
    stylesheet = "treeNavigator.css",
    package = "jsTreeR",
    all_files = FALSE
  )
}

#' @title Tree navigator (Shiny module)
#'
#' @description xxx
#'
#' @param id xxx
#' @param width xxx
#' @param height xxx
#' @param rootFolder xx
#' @param search xx
#' @param pattern xx
#' @param all.files xx
#'
#' @return xxx
#'
#' @name treeNavigator
#'
#' @importFrom shiny NS moduleServer reactiveVal observeEvent
#' @importFrom htmltools tagList
#' @export
#'
#' @examples
#' ###
treeNavigatorUI <- function(id, width = "100%", height = "auto"){
  outputId <- NS(id, "treeNavigator___")
  tree <- jstreeOutput(outputId, width = width, height = height)
  tagList(tree, treeNavigatorDep())
}

#' @rdname treeNavigator
#' @export
treeNavigatorServer <- function(
  id, rootFolder, search = TRUE,
  pattern = NULL, all.files = TRUE
){
  moduleServer(id, function(input, output, session){
    output[["treeNavigator___"]] <- renderJstree({
      jstree(
        nodes = list(
          list(
            text = normalizePath(rootFolder, winslash = "/", mustWork = TRUE),
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
        search = search,
        selectLeavesOnly = TRUE
      )
    })

    observeEvent(input[["path_from_js"]], {
      lf <- list.files_and_dirs(
        input[["path_from_js"]],
        pattern = pattern, all.files = all.files
      )
      fi <- file.info(lf, extra_cols = FALSE)
      x <- list(
        "elem"   = as.list(basename(lf)),
        "folder" = as.list(fi[["isdir"]])
      )
      session$sendCustomMessage("getChildren", x)
    })

    Paths <- reactiveVal()
    observeEvent(input[["treeNavigator____selected_paths"]], {
      Paths(
        vapply(
          input[["treeNavigator____selected_paths"]], `[[`,
          character(1L), "path"
        )
      )
    })

    Paths
  })
}
