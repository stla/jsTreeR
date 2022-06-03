list.files_and_dirs <- function(path, pattern, all.files){
  lfs <- list.files(
    path, pattern = pattern, all.files = all.files,
    full.names = TRUE, no.. = TRUE
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
#' @description A Shiny module allowing to render a files and folders
#'   navigator in the server side file system.
#'
#' @param id an ID string; the one passed to \code{treeNavigatorUI} and
#'   the one passed to \code{treeNavigatorServer} must be identical,
#'   must not contain the \code{"-"} character, and must be a valid HTML
#'   id attribute
#' @param width,height arguments passed to \code{\link{jstreeOutput}}
#' @param rootFolder path to the root folder in which you want to
#'   navigate
#' @param search,wholerow,contextMenu arguments passed to \code{\link{jstree}}
#' @param theme the \strong{jsTree} theme, \code{"default"} or \code{"proton"}
#' @param pattern,all.files arguments passed to \code{\link[base]{list.files}}
#' @param ... values passed to \code{\link[shiny]{req}}
#'
#' @return The \code{treeNavigatorUI} function returns a \code{shiny.tag.list}
#'   object to be included in a Shiny UI definition, and the function
#'   \code{treeNavigatorServer}, to be included in a Shiny server definition,
#'   returns a reactive value containing the selected file paths of the tree
#'   navigator.
#'
#' @name treeNavigator-module
#'
#' @importFrom shiny NS moduleServer reactiveVal observeEvent req
#' @importFrom htmltools tagList
#' @export
#'
#' @examples
#' library(shiny)
#' library(jsTreeR)
#'
#' css <- HTML("
#'   .flexcol {
#'     display: flex;
#'     flex-direction: column;
#'     width: 100%;
#'     margin: 0;
#'   }
#'   .stretch {
#'     flex-grow: 1;
#'     height: 1px;
#'   }
#'   .bottomright {
#'     position: fixed;
#'     bottom: 0;
#'     right: 15px;
#'     min-width: calc(50% - 15px);
#'   }
#' ")
#'
#' ui <- fixedPage(
#'   tags$head(
#'     tags$style(css)
#'   ),
#'   class = "flexcol",
#'
#'   br(),
#'
#'   fixedRow(
#'     column(
#'       width = 6,
#'       treeNavigatorUI("explorer")
#'     ),
#'     column(
#'       width = 6,
#'       tags$div(class = "stretch"),
#'       tags$fieldset(
#'         class = "bottomright",
#'         tags$legend(
#'           tags$h1("Selections:", style = "float: left;"),
#'           downloadButton(
#'             "dwnld",
#'             class = "btn-primary btn-lg",
#'             style = "float: right;",
#'             icon  = icon("save")
#'           )
#'         ),
#'         verbatimTextOutput("selections")
#'       )
#'     )
#'   )
#' )
#' server <- function(input, output, session){
#'
#'   Paths <- treeNavigatorServer(
#'     "explorer", rootFolder = getwd(),
#'     search = list( # (search in the visited folders only)
#'       show_only_matches  = TRUE,
#'       case_sensitive     = TRUE,
#'       search_leaves_only = TRUE
#'     )
#'   )
#'
#'   output[["selections"]] <- renderPrint({
#'     cat(Paths(), sep = "\n")
#'   })
#'
#'   output[["dwnld"]] <- downloadHandler(
#'     filename = "myArchive.zip",
#'     content = function(file){
#'       zip(file, files = Paths())
#'     }
#'   )
#'
#' }
#'
#' if(interactive()) shinyApp(ui, server)
treeNavigatorUI <- function(id, width = "100%", height = "auto"){
  if(grepl("-", id)){
    stop("The `id` must not contain a minus sign.")
  }
  outputId <- NS(id, "treeNavigator___")
  tree <- jstreeOutput(outputId, width = width, height = height)
  tagList(tree, treeNavigatorDep())
}

#' @rdname treeNavigator-module
#' @export
treeNavigatorServer <- function(
  id, rootFolder, search = TRUE, wholerow = FALSE, contextMenu = FALSE,
  theme = "proton", pattern = NULL, all.files = TRUE, ...
){
  theme <- match.arg(theme, c("default", "proton"))
  moduleServer(id, function(input, output, session){
    output[["treeNavigator___"]] <- renderJstree({
      req(...)
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
        theme = theme,
        checkboxes = TRUE,
        search = search,
        wholerow = wholerow,
        contextMenu = contextMenu,
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
