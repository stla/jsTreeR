#' @title Folder gadget
#' @description Shiny gadget allowing to manipulate one or more folders.
#'
#' @param dirs character vector of paths to some folders
#' @param tabs logical, whether to display the trees in tabs; this option is
#'   effective only when there are two folders in the \code{dirs} argument
#' @param recursive,all.files options passed to \code{\link{list.files}};
#'   even if \code{all.files = TRUE}, \code{'.git'} and \code{'.Rproj.user'}
#'   folders are always discarded
#' @param trash logical, whether to add a trash to the gadget, allowing to
#'   restore the files or folders you delete
#'
#' @return No return value, just launches a Shiny gadget.
#'
#' @note You can run the gadget for the current directory from the Addins menu
#'   within RStudio ('Explore current folder').
#'
#' @import shiny miniUI
#' @importFrom rstudioapi getThemeInfo navigateToFile sendToConsole isAvailable
#' @importFrom tools file_ext
#' @importFrom shinyAce aceEditor
#' @importFrom stats setNames
#' @importFrom base64enc dataURI
#' @importFrom utils combn head tail
#' @importFrom R.utils copyDirectory
#' @export
#' @examples library(jsTreeR)
#'
#' # copy a folder to a temporary location for the illustration:
#' tmpDir <- tempdir()
#' folder <- file.path(tmpDir, "htmlwidgets")
#' htmlwidgets <- system.file("htmlwidgets", package = "jsTreeR")
#' R.utils::copyDirectory(htmlwidgets, folder)
#' # we use a copy because the actions performed in the gadget are
#' # actually executed on the files system!
#'
#' # explore and manipulate the folder (drag-and-drop, right-click):
#' if(interactive()){
#'   folderGadget(folder)
#' }
#'
#' # the 'trash' option allows to restore the elements you delete:
#' if(interactive()){
#'   folderGadget(folder, trash = TRUE)
#' }
#'
#' # you can open several folders:
#' folder1 <- file.path(folder, "lib")
#' folder2 <- file.path(folder, "gadget")
#' if(interactive()){
#'   folderGadget(c(folder1, folder2))
#' }
folderGadget <- function(
  dirs = ".", tabs = FALSE, recursive = TRUE, all.files = FALSE, trash = FALSE
) {

  stopifnot(is.character(dirs))
  lapply(dirs, function(dir){
    if(!dir.exists(dir)){
      stop(sprintf('"%s" is not a directory.', dir))
    }
  })

  if(!is.element("jsTreeR", .packages())){
    attachNamespace("jsTreeR")
  }

  rstudio <- isAvailable()

  icons <- list(
    dockerfile = "supertinyicon-docker",
    gitignore = "supertinyicon-git",
    jl = "supertinyicon-julia",
    js = "supertinyicon-javascript",
    jsx = "supertinyicon-react",
    py = "supertinyicon-python",
    scss = "supertinyicon-sass",
    json = "supertinyicon-json",
    java = "supertinyicon-java",
    md = "supertinyicon-markdown",
    markdown = "supertinyicon-markdown",
    rmd = "supertinyicon-markdown",
    pdf = "supertinyicon-pdf",
    rs = "supertinyicon-rust",
    ru = "supertinyicon-ruby",
    svg = "supertinyicon-svg",
    c = "othericon-c",
    cpp = "othericon-cpp",
    "c++" = "othericon-cpp",
    h = "othericon-c",
    hpp = "othericon-cpp",
    css = "othericon-css",
    hs = "othericon-haskell",
    html = "othericon-html",
    rhtml = "othericon-html",
    r = "othericon-r",
    xls = "othericon-excel",
    xlsm = "othericon-excel",
    xlsx = "othericon-excel",
    yaml = "othericon-yaml"
  )

  js <- function(treeId){
    JS(
      "function(node) {",
      sprintf("  var tree = $(\"#%s\").jstree(true);", treeId),
      "  var items;",
      "  if(node.type === \"file\" || exts.indexOf(node.type) > -1) {",
      "    var ext = fileExtension(node.text);",
      "    items = Items(tree, node, false);",
      "    if(!isBinary(ext)) {",
      "      items = $.extend(items, items_file(tree, node));",
      "    }",
      "    if(isImage(ext)) {",
      "      items = $.extend(items, item_image(tree, node, ext));",
      "    } else if(ext === 'pdf') {",
      "      items = $.extend(items, item_pdf(tree, node));",
      "    }",
      "  } else {",
      "    items = $.extend(",
      "      $.extend(item_create(tree, node), Items(tree, node, true)),",
      "      item_rerun(tree, node)",
      "    );",
      "  }",
      "  return items;",
      "}"
    )
  }

  makeNodes <- function(files, dirs, icons){
    exts <- names(icons)
    sep <- .Platform$file.sep
    dfs <- lapply(strsplit(files, sep), function(s){
      item <-
        Reduce(function(a,b) paste0(a,sep,b), s[-1L], s[1L], accumulate = TRUE)
      data.frame(
        item = item,
        parent = c("root", item[-length(item)]),
        stringsAsFactors = FALSE
      )
    })
    dat <- dfs[[1L]]
    for(i in 2L:length(dfs)){
      dat <- merge(dat, dfs[[i]], all = TRUE)
    }
    f <- function(parent){
      i <- match(parent, dat$item)
      item <- dat$item[i]
      children <- dat$item[dat$parent==item]
      label <- tail(strsplit(item, sep)[[1L]], 1L)
      if(item %in% dirs){
        list(
          text = label,
          children = lapply(children, f),
          type = "folder"
        )
      }else{
        ext <- tolower(file_ext(label))
        list(
          text = label,
          type = ifelse(ext %in% exts, ext, "file")
        )
      }
    }
    nodes <- lapply(dat$item[dat$parent == "root"], f)
    nodes[[1L]][["state"]] <- list(opened = TRUE)
    nodes
  }

  readFolder <- function(dir, recursive, all.files){
    folder <- normalizePath(dir, winslash = "/")
    splittedPath <- strsplit(folder, .Platform$file.sep)[[1L]]
    path <- paste0(head(splittedPath,-1L), collapse = .Platform$file.sep)
    parent <- tail(splittedPath, 1L)
    folders <- list.dirs(folder, full.names = FALSE, recursive = recursive)
    folders_fullNames <-
      list.dirs(folder, full.names = TRUE, recursive = recursive)
    emptyFolders <- folders[vapply(folders_fullNames, function(folder){
      length(list.files(folder, include.dirs = TRUE, recursive = FALSE)) == 0L
    }, logical(1L))]
    lf <- list.files(
      folder, recursive = recursive,
      all.files = all.files, no.. = TRUE
    )
    re <- sprintf(
      paste0(
        "(^\\.git$|%s+\\.git$|%s?\\.git%s+|^\\.Rproj\\.user$|",
        "%s+\\.Rproj\\.user$|%s?\\.Rproj\\.user%s+)"
      ),
      .Platform$file.sep, .Platform$file.sep, .Platform$file.sep,
      .Platform$file.sep, .Platform$file.sep, .Platform$file.sep
    )
    emptyFolders <- emptyFolders[!grepl(re, emptyFolders)]
    if(all.files){
      lf <- lf[!grepl(re, lf)]
    }
    folderContents <- c(emptyFolders, lf)
    list(
      parent = parent,
      folderContents = folderContents,
      folders = folders,
      path = path,
      folder = folder
    )
  }

  jstrees <- paste0("jstree", seq_along(dirs))
  ndirs <- length(dirs)
  paths <- setNames(character(ndirs), jstrees)
  parents <- folders <- character(ndirs)
  nodes <- setNames(vector(mode = "list", length = ndirs), jstrees)

  for(i in seq_along(dirs)){
    Folder <- readFolder(dirs[i], recursive, all.files)
    paths[i] <- Folder[["path"]]
    parents[i] <- Folder[["parent"]]
    folders[i] <- Folder[["folder"]]
    nodes[[i]] <- with(Folder, makeNodes(
      file.path(parent, folderContents),
      c(parent, file.path(parent, folders[-1L])),
      icons
    ))
  }

  renameDuplicates <- function(x){
    if(any(dups <- duplicated(x))){
      while(any(dups)){
        val <- x[match(TRUE, dups)]
        indices <- which(x == val)
        x[indices] <- paste0(val, " (", seq_along(indices), ")")
        dups <- duplicated(x)
      }
    }
    x
  }

  parents <- renameDuplicates(parents)

  if(trash){
    parents <- c(parents, "_TRASH_")
    jstrees <- c(jstrees, "trash")
    trashNodes <- lapply(seq_len(ndirs), function(i){
      list(
        text = parents[i],
        id = paste0("trash-", jstrees[i]),
        type = "folder",
        state = list(opened = TRUE)
      )
    })
    grid <- list(
      columns = list(
        list(
          minWidth = 200,
          header = "Element",
          headerClass = "bolditalic yellow centered",
          wideValueClass = "cssclass"
        ),
        # list(
        #   maxWidth = 200,
        #   value = "location",
        #   title = "location",
        #   header = "Location",
        #   wideValueClass = "cssclass",
        #   headerClass = "bolditalic yellow centered",
        #   wideCellClass = "centered ellipsis"
        # ),
        list(
          width = 100,
          value = "button",
          header = "Restore?",
          wideValueClass = "cssclass",
          headerClass = "bolditalic yellow centered",
          wideCellClass = "centered"
        )
      )
      #      width = 500
    )
  }

  toPattern <- function(x){
    gsub(
      "(\\.|\\||\\(|\\)|\\[|\\]|\\{|\\}|\\^|\\$|\\*|\\+|\\?)",
      "\\\\\\1",
      x
    )
  }
  if(ndirs > 1L){
    if(anyDuplicated(folders)){
      warning(
        "There are identical folders. ",
        "The gadget may have a strange behavior.",
        immediate. = TRUE
      )
    }else{
      combs <- combn(folders, m = 2L)
      inclusion <- any(
        apply(combs, 2L, function(pair){
          grepl(paste0("^", toPattern(pair[1L])), pair[2L]) ||
            grepl(paste0("^", toPattern(pair[2L])), pair[1L])
        })
      )
      if(inclusion){
        warning(
          "One folder is a subfolder of another one. ",
          "The gadget may have a strange behavior.",
          immediate. = TRUE
        )
      }
    }
  }

  types <- append(list(
    file = list(
      icon = "glyphicon glyphicon-file brown"
    ),
    folder = list(
      icon = "fa fa-folder folder"
    )
  ), setNames(lapply(names(icons), function(ext){
    list(icon = icons[[ext]])
  }), names(icons)))

  checkCallback <- JS(
    "function(operation, node, parent, position, more) {",
    "  if(operation === 'move_node') {",
    "    if(parent.id === '#' || parent.type !== 'folder') {",
    "      return false;",
    "    }",
    "  }",
    "  return true;",
    "}"
  )

  theme <- ifelse(rstudio, getThemeInfo()[["editor"]], "cobalt")

  if(ndirs != 2L){
    tabs <- ndirs >= 3L
  }

  imageMIME <-
    c(
      gif = "image/gif",
      png = "image/png",
      jpg = "image/jpeg",
      jpeg = "image/jpeg",
      tif = "image/tiff",
      tiff = "image/tiff",
      bmp = "image/bmp",
      ico = "image/vnd.microsoft.icon",
      svg = "image/svg+xml",
      webp = "image/webp"
    )

  www <- function(file){
    system.file("htmlwidgets", "gadget", file, package = "jsTreeR")
  }

  ui <- miniPage(

    tags$head(
      includeScript(www("pdfobject.min.js")),
      includeCSS(www("gadget.css")),
      if(rstudio){
        tags$script(HTML("var rstudio = true;"))
      }else{
        tags$script(HTML("var rstudio = false;"))
      },
      if(trash){
        tagList(
          tags$script(HTML("var Trash = true;")),
          includeCSS(www("trash.css")),
          includeScript(www("trash.js"))
        )
      }else{
        tags$script(HTML("var Trash = false;"))
      },
      tags$script(
        HTML(
          sprintf("var exts = [%s];", toString(paste0("'", names(icons), "'"))),
          sprintf("var sep = \"%s\";", .Platform$file.sep),
          sprintf(
            "var imageExts = [%s];",
            toString(paste0("'", names(imageMIME), "'"))
          )
        )
      ),
      includeScript(www("gadget.js"))
    ),

    if(tabs || trash){
      do.call(function(...){
        miniTabstripPanel(
          ...,
          between = miniButtonBlock(
            actionButton("done", "Done", class = "btn-primary"),
            border = NULL
          )
        )
      }, if(tabs || ndirs != 2L){
        lapply(seq_len(ndirs + trash), function(i){
          miniTabPanel(
            if(ndirs > 1L) parents[i],
            icon = if(ndirs == 1L) icon(ifelse(i == 1L, "folder-open", "trash")),
            miniContentPanel(
              jstreeOutput(jstrees[i])
            )
          )
        })
      } else {
        list(
          miniTabPanel(
            NULL,
            icon = icon("folder-open"),
            miniContentPanel(
              do.call(
                fillRow,
                lapply(jstrees[c(1L,2L)], function(id){
                  jstreeOutput(id)
                })
              )
            )
          ),
          # if(trash){
            miniTabPanel(
              NULL,
              icon = icon("trash"),
              miniContentPanel(
                jstreeOutput("trash")
              )
            )
          # }
        )
      })
    }else{
      miniContentPanel(
        miniButtonBlock(
          actionButton("done", "Done", class = "btn-primary"),
          border = NULL
        ),
        if(ndirs == 1L){
          jstreeOutput("jstree1", width = "100%")
        }else{
          do.call(
            fillRow,
            lapply(jstrees, function(id){
              jstreeOutput(id)
            })
          )
        }
      )
    }

  )


  TMPDIR <- tempdir()

  server <- function(input, output, session){

    observeEvent(input[["done"]], {
      stopApp()
    })

    observeEvent(input[["rerun"]], {
      path <- file.path(
        paths[input[["rerun"]][["instance"]]],
        input[["rerun"]][["path"]]
      )
      session$onSessionEnded(function(){
        if(rstudio){
          code <- sprintf("jsTreeR::folderGadget('%s', trash = %s)", path, trash)
          sendToConsole(code)
        }else{
          jsTreeR::folderGadget(path, trash = trash)
        }
      })
      stopApp()
    })

    observeEvent(input[["viewPDF"]], {
      filePath <- file.path(
        paths[input[["viewPDF"]][["instance"]]],
        input[["viewPDF"]][["path"]]
      )
      b64 <- dataURI(file = filePath, mime = "application/pdf")
      script <- HTML(
        sprintf("var b64 = '%s';", b64),
        "PDFObject.embed(b64, '#pdf');"
      )
      showModal(modalDialog(
        tagList(
          tags$div(id = "pdf", style = "height: 70vh;"),
          tags$script(script)
        ),
        easyClose = TRUE,
        size = "l"
      ))
    })

    observeEvent(input[["viewImage"]], {
      filePath <- file.path(
        paths[input[["viewImage"]][["instance"]]],
        input[["viewImage"]][["path"]]
      )
      ext <- input[["viewImage"]][["ext"]]
      if(ext == "svg"){
        tag <- tags$div(
          style =
            "width: 50%; margin-left: auto; margin-right: auto; margin-top: 2%;",
          HTML(suppressWarnings(readLines(filePath)))
        )
      }else{
        tag <- tags$div(
          style = "margin-left: auto; margin-right: auto; margin-top: 2%;",
          tags$img(
            src = dataURI(file = filePath, mime = imageMIME[[ext]]),
            width = "250"
          )
        )
      }
      showModal(modalDialog(
        tag,
        easyClose = TRUE
      ))
    })

    observeEvent(input[["editFile"]], {
      filePath <- file.path(
        paths[input[["editFile"]][["instance"]]],
        input[["editFile"]][["path"]]
      )
      ext <- tolower(file_ext(input[["editFile"]][["path"]]))
      mode <- switch(ext,
                     c = "c_cpp",
                     cpp = "c_cpp",
                     "c++" = "c_cpp",
                     dockerfile = "dockerfile",
                     frag = "glsl",
                     h = "c_cpp",
                     hpp = "c_cpp",
                     css = "css",
                     f = "fortran",
                     f90 = "fortran",
                     gitignore = "gitignore",
                     hs = "haskell",
                     html = "html",
                     java = "java",
                     js = "javascript",
                     jsx = "jsx",
                     json = "json",
                     jl = "julia",
                     tex = "latex",
                     md = "markdown",
                     map = "json",
                     markdown = "markdown",
                     rmd = "markdown",
                     mysql = "mysql",
                     ml = "ocaml",
                     perl = "perl",
                     pl = "perl",
                     php = "php",
                     py = "python",
                     r = "r",
                     rd = "rdoc",
                     rhtml = "rhtml",
                     rnw = "latex",
                     ru = "ruby",
                     rs = "rust",
                     scala = "scala",
                     scss = "scss",
                     sh = "sh",
                     sql = "sql",
                     svg = "svg",
                     txt = "text",
                     ts = "typescript",
                     vb = "vbscript",
                     xml = "xml",
                     yaml = "yaml",
                     yml = "yaml"
      )
      showModal(modalDialog(
        aceEditor(
          "aceEditor",
          value = paste0(suppressWarnings(readLines(filePath)), collapse = "\n"),
          mode = ifelse(is.null(mode), "plain_text", mode),
          theme = gsub(" ", "_", tolower(theme)),
          tabSize = 2,
          height = "60vh"
        ),
        footer = tags$div(
          actionButton(
            "editDone", "Done", class = "btn-success",
            onclick = sprintf("Shiny.setInputValue('filePath', '%s');", filePath)
          ),
          modalButton("Cancel")
        ),
        size = "l"
      ))
    })

    observeEvent(input[["editDone"]], {
      writeLines(input[["aceEditor"]], input[["filePath"]])
      removeModal()
    })

    observeEvent(input[["openFile"]], {
      filePath <- file.path(
        paths[input[["openFile"]][["instance"]]],
        input[["openFile"]][["path"]]
      )
      if(file.exists(filePath)){
        navigateToFile(filePath)
      }
    })

    observeEvent(input[["jsTreeDeleted"]], {
      instance <- input[["jsTreeDeleted"]][["instance"]]
      pathTail <-
        paste0(input[["jsTreeDeleted"]][["path"]], collapse = .Platform$file.sep)
      if(instance != "trash"){
        path <- file.path(paths[instance], pathTail)
        if(file.exists(path)){
          if(trash){
            tmpPath <- file.path(TMPDIR, instance, pathTail)
            if(!dir.exists(d <- dirname(tmpPath))){
              dir.create(d, recursive = TRUE)
            }
            if(dir.exists(path)){
              copyDirectory(path, tmpPath)
            }else{
              file.copy(path, tmpPath)
            }
          }
          unlink(path, recursive = TRUE)
        }
      }
    })

    observeEvent(input[["restore"]], {
      path <- file.path(
        paths[input[["restore"]][["instance"]]],
        input[["restore"]][["path"]]
      )
      tmpPath <- file.path(
        TMPDIR,
        input[["restore"]][["instance"]],
        input[["restore"]][["path"]]
      )
      if(!dir.exists(d <- dirname(path))) dir.create(d, recursive = TRUE)
      if(dir.exists(tmpPath)){
        copyDirectory(tmpPath, path)
      }else{
        file.copy(tmpPath, path)
      }
      unlink(tmpPath, recursive = TRUE)
    })

    observeEvent(input[["createdNode"]], {
      nodePath <- file.path(
        paths[input[["createdNode"]][["instance"]]],
        input[["createdNode"]][["path"]]
      )
      if(input[["createdNode"]][["type"]] == "file"){
        file.create(nodePath)
      }else{
        dir.create(nodePath)
      }
    })

    observeEvent(input[["jsTreeRenamed"]], {
      from = file.path(
        paths[input[["jsTreeRenamed"]][["instance"]]],
        paste0(input[["jsTreeRenamed"]][["from"]], collapse = .Platform$file.sep)
      )
      to = file.path(
        paths[input[["jsTreeRenamed"]][["instance"]]],
        paste0(input[["jsTreeRenamed"]][["to"]], collapse = .Platform$file.sep)
      )
      if(file.exists(from) && from != to){
        file.rename(from, to)
      }
    })

    observeEvent(input[["jsTreeCopied"]], {
      copied <- input[["jsTreeCopied"]]
      from = file.path(
        paths[copied[["from"]][["instance"]]],
        paste0(copied[["from"]][["path"]], collapse = .Platform$file.sep)
      )
      to = file.path(
        paths[copied[["to"]][["instance"]]],
        paste0(copied[["to"]][["path"]], collapse = .Platform$file.sep)
      )
      if(from != to){
        if(!is.null(input[["operation"]]) && input[["operation"]] == "copy"){
          file.copy(from, to)
        }else{
          file.rename(from, to)
        }
      }
    })

    observeEvent(input[["jsTreeMoved"]], { # triggered when moving inside same tree
      moved <- input[["jsTreeMoved"]]
      from = file.path(
        paths[moved[["from"]][["instance"]]],
        paste0(moved[["from"]][["path"]], collapse = .Platform$file.sep)
      )
      to = file.path(
        paths[moved[["to"]][["instance"]]],
        paste0(moved[["to"]][["path"]], collapse = .Platform$file.sep)
      )
      if(from != to){
        file.rename(from, to)
      }
    })

    for(treeId in jstrees){
      local({
        id <- treeId
        if(id != "trash"){
          output[[id]] <- renderJstree({
            jstree(
              nodes[[id]],
              types = types,
              dragAndDrop = TRUE,
              checkboxes = FALSE,
              multiple = FALSE,
              theme = "proton",
              contextMenu = list(select_node = FALSE, items = js(id)),
              checkCallback = checkCallback,
              sort = TRUE,
              search = list(
                show_only_matches = TRUE,
                case_sensitive = FALSE,
                search_leaves_only = FALSE
              )
            )
          })
        }else{
          output[["trash"]] <- renderJstree({
            jstree(
              trashNodes,
              types = types,
              dragAndDrop = FALSE,
              checkboxes = FALSE,
              multiple = FALSE,
              theme = "default",
              contextMenu = FALSE,
              checkCallback = TRUE,
              sort = FALSE,
              search = FALSE,
              grid = grid
            )
          })
          outputOptions(output, "trash", suspendWhenHidden = FALSE)
        }
      })
    }

  }

  runGadget(
    shinyApp(ui, server),
    stopOnCancel = FALSE,
    viewer = if(rstudio) paneViewer() else browserViewer()
  )

}


exploreCurrentDirectory <- function(){
  message("Use 'jsTreeR::folderGadget' for more options.")
  folderGadget(".", recursive = TRUE, all.files = TRUE)
}
