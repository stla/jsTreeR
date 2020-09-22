#' Folder gadget
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
#' @note You can run the gadget for the current directory from the Addins menu
#'   within RStudio ('Explore current folder').
#'
#' @import shiny miniUI
#' @importFrom rstudioapi getThemeInfo navigateToFile
#' @importFrom tools file_ext
#' @importFrom shinyAce aceEditor
#' @importFrom stats setNames
#' @importFrom base64enc dataURI
#' @importFrom utils combn head tail
#' @export
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
      "    items = $.extend(Items(tree, node, false), items_file(tree, node));",
      "    var ext = fileExtension(node.text);",
      "    if(isImage(ext)) {",
      "      items = $.extend(items, item_image(tree, node, ext));",
      "    }",
      "  } else {",
      "    items = $.extend(item_create(tree, node), Items(tree, node, true));",
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
    lapply(dat$item[dat$parent == "root"], f)
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
    if(all.files){
      re <- sprintf(
        paste0(
          "(^\\.git$|%s+\\.git$|%s?\\.git%s+|^\\.Rproj\\.user$|",
          "%s+\\.Rproj\\.user$|%s?\\.Rproj\\.user%s+)"
        ),
        .Platform$file.sep, .Platform$file.sep, .Platform$file.sep,
        .Platform$file.sep, .Platform$file.sep, .Platform$file.sep
      )
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
    parents <- c(parents, "_trash_")
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
    gridStyle <- HTML(
      ".bolditalic {font-weight: bold; font-style: italic; font-size: large;}",
      ".yellow {background-color: yellow !important;}",
      ".centered {text-align: center; font-family: cursive;}",
      ".ellipsis {text-overflow: ellipsis;}"
    )
    restoreButtonStyle <- HTML(
      ".btn-restore {padding: 0 10px;}"
    )
    restoreButtonOnClick <- HTML(
      "function getChildByText(parent, text) {",
      "  var texts = parent.children.map(function(child) {",
      "    return child.text;",
      "  });",
      "  var index = texts.indexOf(text);",
      "  if(index > -1) {",
      "    return parent.children[index];",
      "  } else {",
      "    return null;",
      "  }",
      "}",
      "function restoreNode(tree, path, nodeAsJSON) {",
      "  path = path.slice();",
      "  path.shift();", #  path.pop();
      "  var parent = getNodesWithChildren2(tree.get_json(), ['text','id'])[0];",
      "  var head = path.shift();",
      "  var child = getChildByText(parent, head);",
      "  while(child !== null && path.length > 0) {",
      "    parent = child;",
      "    head = path.shift();",
      "    child = getChildByText(parent, head);",
      "  }",
      "  path = [head].concat(path);",
      "  var id = parent.id;",
      "  for(var i = 0; i < path.length - 1; i++) {",
      "    id = tree.create_node(id, {text: path[i], type: 'folder'});",
      "  }",
      "  tree.create_node(id, nodeAsJSON);",
      "}",
      "function restore(treeId, path, nodeAsJSON) {",
      "  var tree = $('#' + treeId).jstree(true);",
      "  restoreNode(tree, path, nodeAsJSON);",
      "  var type = nodeAsJSON.type === 'folder' ? 'folder' : 'file';",
      "  Shiny.setInputValue('restore', {",
      "    instance: tree.element.attr('id'), path: path.join(sep), type: type",
      "  });",
      "}"
    )
    addRestoreButton <- HTML(
      "function addRestoreButton(treeId, path, nodeAsJSON) {",
      "  var attrs = `data-instance='${treeId}' data-path='${JSON.stringify(path)}' data-node='${JSON.stringify(nodeAsJSON)}'`;",
      "  var onclick = 'xxx';",
      "  var btn = `<button class='btn btn-sm btn-restore' ${attrs}>restore</button>`;",
      "  var trashTree = $('#trash').jstree(true);",
      "  var node = {",
      "    id: 'xxx',",
      "    text: nodeAsJSON.text,",
      "    type: nodeAsJSON.type,",
      # "    data: {location: path.join(sep), button: btn},",
      # "    a_attr: {title: nodeAsJSON.text},",
      # "    li_attr: {style: 'text-overflow: ellipsis;'}", # no effect
      "    data: {button: btn},",
      "    li_attr: {title: path.join(sep)}",
      "  };",
      "  var id = trashTree.create_node('trash-' + treeId, node);",
      # "  $(btn).on('click', function() {",
      # "    restore(treeId, path, nodeAsJson);",
      # "    trashTree.delete_node(id);",
      # "  });",
      "}"
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
      icon = "glyphicon glyphicon-file"
    ),
    folder = list()
  ), setNames(lapply(names(icons), function(ext){
    list(icon = icons[[ext]])
  }), names(icons)))

  checkCallback <- JS(
    "function(operation, node, parent, position, more) {",
    "  if(operation === 'move_node') {",
    "    if(parent.id === '#' || parent.type === 'file') {",
    "      return false;",
    "    }",
    "  }",
    "  return true;",
    "}"
  )

  themeInfo <- getThemeInfo()

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

  ui <- miniPage(

    tags$head(
      tags$style(
        HTML(
          c(
            ".jstree-proton {font-weight: bold;}",
            ".jstree-anchor {font-size: medium;}",
            "input[id$='-search'] {background-color: seashell;}",
            "#shiny-modal .modal-dialog div[class^='modal-'] {",
            "  background-color: maroon;",
            "}",
            ".gadget-block-button {background-color: transparent;}",
            ".gadget-tabs-container ul.gadget-tabs>li.active>a {",
            "  font-weight: bold;",
            "  background-color: paleturquoise;",
            "}",
            ".gadget-tabs-container ul.gadget-tabs>li:not(.active)>a {",
            "  background-color: rgba(175,238,238,0.5);",
            "}",
            ".ace_scrollbar::-webkit-scrollbar-track {",
            "  border-radius: 10px;",
            "  background-color: crimson;",
            "}",
            ".ace_scrollbar::-webkit-scrollbar {",
            "  background-color: transparent;",
            "}",
            ".ace_scrollbar::-webkit-scrollbar-thumb {",
            "  border-radius: 10px;",
            "  background-color: tomato;",
            "}"
          )
        )
      ),
      if(trash){
        tagList(
          tags$script(HTML("var Trash = true;")),
          tags$style(gridStyle),
          tags$style(restoreButtonStyle),
          tags$script(restoreButtonOnClick),
          tags$script(addRestoreButton)
        )
      }else{
        tags$script(HTML("var Trash = false;"))
      },
      tags$script(
        HTML(
          "var copiedNode = null;",
          sprintf("var exts = [%s];", toString(paste0("'", names(icons), "'"))),
          sprintf("var sep = \"%s\";", .Platform$file.sep),
          sprintf(
            "var imageExts = [%s];",
            toString(paste0("'", names(imageMIME), "'"))
          ),
          "function fileExtension(fileName) {",
          "  if(/\\./.test(fileName)) {",
          "    var splitted = fileName.split('.');",
          "    return splitted[splitted.length - 1].toLowerCase();",
          "  } else {",
          "    return null;",
          "  }",
          "}",
          "function isImage(ext) {",
          "  return imageExts.indexOf(ext) > -1;",
          "}",
          "function item_image(tree, node, ext) {",
          "  return {",
          "    Image: {",
          "      separator_before: true,",
          "      separator_after: true,",
          "      label: \"View image\",",
          "      action: function(obj) {",
          "        Shiny.setInputValue(",
          "          'viewImage',",
          "          {",
          "            instance: tree.element.attr('id'),",
          "            path: tree.get_path(node, sep),",
          "            ext: ext",
          "          }",
          "        );",
          "      }",
          "    }",
          "  };",
          "}",
          "function Items(tree, node, paste) {",
          "  return {",
          "    Copy: {",
          "      separator_before: true,",
          "      separator_after: false,",
          "      label: \"Copy\",",
          "      action: function(obj) {",
          "        tree.copy(node);",
          "        copiedNode = {node: node, operation: 'copy'};", # use get_buffer and clear_buffer instead ?
          "      }",
          "    },",
          "    Cut: {",
          "      separator_before: false,",
          "      separator_after: !paste,",
          "      label: \"Cut\",",
          "      action: function(obj) {",
          "        tree.cut(node);",
          "        copiedNode = {instance: tree, node: node, operation: 'cut'};",
          "      }",
          "    },",
          "    Paste: paste ? {",
          "      separator_before: false,",
          "      separator_after: true,",
          "      label: \"Paste\",",
          "      _disabled: copiedNode === null,",
          "      action: function(obj) {",
          "        var children = tree.get_node(node).children.map(",
          "          function(child) {return tree.get_text(child);}",
          "        );",
          "        if(children.indexOf(copiedNode.node.text) === -1) {",
          #"          tree.paste(node);",
          "          var operation = copiedNode.operation;",
          "          tree.copy_node(copiedNode.node, node, 0, function() {",
          "            Shiny.setInputValue('operation', operation);",
          "            setTimeout(function() {",
          "              Shiny.setInputValue('operation', 'rename');",
          "            }, 0);",
          "          });",
          "          if(operation === 'cut') {",
          "            copiedNode.instance.delete_node(copiedNode.node);",
          "          }",
          "          copiedNode = null;",
          "        }",
          "      }",
          "    } : null,",
          "    Rename: {",
          "      separator_before: true,",
          "      separator_after: false,",
          "      label: \"Rename\",",
          "      action: function(obj) {",
          "        tree.edit(node, null, function() {",
          "          var nodeType = tree.get_type(node);",
          "          if(nodeType === 'file' || exts.indexOf(nodeType) > -1) {",
          "            var nodeText = tree.get_text(node);",
          "            var ext = fileExtension(nodeText);",
          "            if(ext !== null) {",
          "              if(exts.indexOf(ext) > -1) {",
          "                tree.set_type(node, ext);",
          "              } else {",
          "                tree.set_type(node, 'file');",
          "              }",
          "            }",
          "          }",
          "        });",
          "      }",
          "    },",
          "    Remove: {",
          "      separator_before: false,",
          "      separator_after: true,",
          "      label: \"Remove\",",
          "      action: function(obj) {",
          "        if(Trash) {",
          "          addRestoreButton(",
          "            tree.element.attr('id'),",
          "            tree.get_path(node),",
          "            extractKeysWithChildren2(",
          "              tree.get_json(node), ['text','type']",
          "            )",
          "          );",
          "        }",
          "        tree.delete_node(node);",
          "      }",
          "    }",
          "  };",
          "}",
          "function items_file(tree, node) {",
          "  return {",
          "    Open: {",
          "      separator_before: true,",
          "      separator_after: false,",
          "      label: \"Open in RStudio\",",
          "      action: function(obj) {",
          "        Shiny.setInputValue(",
          "          'openFile',",
          "          {",
          "            instance: tree.element.attr('id'),",
          "            path: tree.get_path(node, sep)",
          "          }",
          "        );",
          "      }",
          "    },",
          "    Edit: {",
          "      separator_before: false,",
          "      separator_after: true,",
          "      label: \"Edit\",",
          "      action: function(obj) {",
          "        Shiny.setInputValue(",
          "          'editFile',",
          "          {",
          "            instance: tree.element.attr('id'),",
          "            path: tree.get_path(node, sep)",
          "          },",
          "          {priority: 'event'}",
          "        );",
          "      }",
          "    }",
          "  };",
          "}",
          "function item_create(tree, node) {",
          "  return {",
          "    Create: {",
          "      separator_before: true,",
          "      separator_after: true,",
          "      label: \"Create\",",
          "      action: false,",
          "      submenu: {",
          "        File: {",
          "          separator_before: true,",
          "          separator_after: false,",
          "          label: \"File\",",
          "          action: function(obj) {",
          "            var children = tree.get_node(node).children.map(",
          "              function(child) {return tree.get_text(child);}",
          "            );",
          "            node = tree.create_node(node, {type: \"file\"});",
          "            tree.edit(",
          "              node, null, function() {",
          "                var nodeText = tree.get_text(node);",
          "                if(children.indexOf(nodeText) > -1) {",
          "                  tree.delete_node(node);",
          "                } else {",
          "                  if(/\\./.test(nodeText)) {",
          "                    var splitted = nodeText.split('.');",
          "                    var ext = splitted[splitted.length - 1]",
          "                                .toLowerCase();",
          "                    if(exts.indexOf(ext) > -1) {",
          "                      tree.set_type(node, ext);",
          "                    }",
          "                  }",
          "                  Shiny.setInputValue(",
          "                    'createdNode',",
          "                    {",
          "                      instance: tree.element.attr('id'),",
          "                      type: 'file',",
          "                      path: tree.get_path(node, sep)",
          "                    }",
          "                  );",
          "                }",
          "              }",
          "            );",
          "          }",
          "        },",
          "        Folder: {",
          "          separator_before: false,",
          "          separator_after: true,",
          "          label: \"Folder\",",
          "          action: function(obj) {",
          "            var children = tree.get_node(node).children.map(",
          "              function(child) {return tree.get_text(child);}",
          "            );",
          "            node = tree.create_node(node, {type: \"folder\"});",
          "            tree.edit(",
          "              node, null, function() {",
          "                if(children.indexOf(tree.get_text(node)) > -1) {",
          "                  tree.delete_node(node);",
          "                } else {",
          "                  Shiny.setInputValue(",
          "                    'createdNode',",
          "                    {",
          "                      instance: tree.element.attr('id'),",
          "                      type: 'folder',",
          "                      path: tree.get_path(node, sep)",
          "                    }",
          "                  );",
          "                }",
          "              }",
          "            );",
          "          }",
          "        }",
          "      }",
          "    }",
          "  };",
          "}"
        )
      )
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
            parents[i],
            miniContentPanel(
              jstreeOutput(jstrees[i])
            )
          )
        })
      } else {
        list(
          miniTabPanel(
            "folders",
            miniContentPanel(
              do.call(
                fillRow,
                lapply(jstrees[c(1L,2L)], function(id){
                  jstreeOutput(id)
                })
              )
            )
          ),
          if(trash){
            miniTabPanel(
              "_trash_",
              miniContentPanel(
                jstreeOutput("trash")
              )
            )
          }
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


  server <- function(input, output){

    observeEvent(input[["done"]], {
      stopApp()
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
          theme = gsub(" ", "_", tolower(themeInfo[["editor"]])),
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
      if(instance != "trash"){
        path <- file.path(
          paths[instance],
          paste0(input[["jsTreeDeleted"]][["path"]], collapse = .Platform$file.sep)
        )
        if(file.exists(path)){
          unlink(path, recursive = TRUE)
        }
      }
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

  runGadget(shinyApp(ui, server), stopOnCancel = FALSE)

}


exploreCurrentDirectory <- function(){
  message("Use 'jsTreeR::folderGadget' for more options.")
  folderGadget(".", recursive = TRUE, all.files = TRUE)
}
