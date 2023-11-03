#' @title HTML widget displaying an interactive tree
#' @description Create a HTML widget displaying an interactive tree.
#'
#' @param nodes data, a list of nodes; each node is a list with a required
#'   field \code{text}, a character string labeling the node, and optional
#'   fields
#'   \describe{
#'     \item{\code{children}}{
#'       a list of nodes
#'     }
#'     \item{\code{data}}{
#'       a named list of data to attach to the node; see the
#'       \link[jsTreeR:jstreeExamples]{Shiny examples}
#'     }
#'     \item{\code{icon}}{
#'       space-separated HTML class names defining an icon, e.g.
#'       \code{"glyphicon glyphicon-flash"} or \code{"fa fa-folder"};
#'       one can also get an icon from an image file in a Shiny app, see the
#'       \emph{imageIcon} \link[jsTreeR:jstreeExample]{Shiny example};
#'       you can also use a super tiny icon, e.g. \code{"supertinyicon-julia"};
#'       see the \emph{SuperTinyIcons}
#'       \link[jsTreeR:jstreeExample]{Shiny example} showing all available
#'       such icons
#'     }
#'     \item{\code{type}}{
#'       a character string for usage with the \code{types} option; see first
#'       example
#'     }
#'     \item{\code{state}}{
#'       a named list defining the state of the node, with four possible fields,
#'       each being \code{TRUE} or \code{FALSE}:
#'       \describe{
#'         \item{\code{opened}}{
#'           whether the node should be initially opened
#'         }
#'         \item{\code{selected}}{
#'           whether the node should be initially selected
#'         }
#'         \item{\code{disabled}}{
#'           whether the node should be disabled
#'         }
#'         \item{\code{checked}}{
#'           whether the node should be initially checked, effective
#'           only when the \code{checkboxes} option is \code{TRUE}
#'         }
#'       }
#'     }
#'     \item{\code{a_attr}}{
#'       a named list of attributes for the node label, such as
#'       \code{list(title = "I'm a tooltip", style = "color: red;")}
#'     }
#'     \item{\code{li_attr}}{
#'       a named list of attributes for the whole node, including its children,
#'       such as
#'       \code{list(title = "I'm a tooltip", style = "background-color: pink;")}
#'     }
#'   }
#'   There are some alternatives for the \code{nodes} argument;
#'   see \href{https://github.com/vakata/jstree/wiki#populating-the-tree-using-ajax}{Populating the tree using AJAX},
#'   \href{https://github.com/vakata/jstree/wiki#populating-the-tree-using-ajax-and-lazy-loading-nodes}{Populating the tree using AJAX and lazy loading nodes}
#'   and \href{https://github.com/vakata/jstree/wiki#populating-the-tree-using-a-callback-function}{Populating the tree using a callback function}.
#' @param elementId a HTML id for the widget (useless for common usage)
#' @param selectLeavesOnly logical, for usage in Shiny, whether to get only
#'   selected leaves
#' @param checkboxes logical, whether to enable checkboxes next to each node;
#'   this makes easier the selection of multiple nodes
#' @param checkWithText logical, whether the checkboxes must be selected when
#'   clicking on the text of a node
#' @param search either a logical value, whether to enable the search
#'   functionality with default options, or a named list of options for the
#'   search functionality; see the \emph{SuperTinyIcons}
#'   \link[jsTreeR:jstreeExample]{Shiny example}
#'   and the \href{https://www.jstree.com/api/}{jsTree API documentation} for
#'   the list of possible options
#' @param searchtime currently ignored
#' @param dragAndDrop logical, whether to allow the rearrangement of the nodes
#'   by dragging and dropping
#' @param dnd a named list of options related to the drag-and-drop
#'   functionality, e.g. the \code{is_draggable} function to define which nodes
#'   are draggable; see the first example and the
#'   \href{https://www.jstree.com/api/}{jsTree API documentation} for the list
#'   of possible options
#' @param multiple logical, whether to allow multiselection
#' @param types a named list of node properties; see first example
#' @param sort logical, whether to sort the nodes
#' @param unique logical, whether to ensure that no node label is duplicated
#' @param wholerow logical, whether to highlight whole selected rows
#' @param contextMenu either a logical value, whether to enable a context menu
#'   to create/rename/delete/cut/copy/paste nodes, or a list of options; see
#'   the \href{https://www.jstree.com/api/}{jsTree API documentation} for the
#'   possible options
#' @param checkCallback either \code{TRUE} to allow to perform some actions
#'   such as creating a new node, or a JavaScript function; see the example
#'   where this option is used to define restrictions on the drag-and-drop
#'   behavior
#' @param grid list of settings for the grid; see the second example, the
#'   \emph{grid} \link[jsTreeR:jstreeExample]{Shiny example}, and the web page
#'   \href{https://github.com/deitch/jstree-grid/#options}{github.com/deitch/jstree-grid}
#'   for the list of all available options
#' @param theme jsTree theme, one of \code{"default"},
#'   \code{"default-dark"}, or \code{"proton"}
#'
#' @return A \code{htmlwidget} object.
#'
#' @import htmlwidgets
#' @importFrom htmltools htmlDependency
#' @importFrom fontawesome fa_html_dependency
#' @importFrom shiny bootstrapLib
#' @importFrom jquerylib jquery_core
#' @export
#'
#' @examples # example illustrating the 'dnd' and 'checkCallback' options ####
#'
#' library(jsTreeR)
#'
#' nodes <- list(
#'   list(
#'     text = "RootA",
#'     type = "root",
#'     children = list(
#'       list(
#'         text = "ChildA1",
#'         type = "child"
#'       ),
#'       list(
#'         text = "ChildA2",
#'         type = "child"
#'       )
#'     )
#'   ),
#'   list(
#'     text = "RootB",
#'     type = "root",
#'     children = list(
#'       list(
#'         text = "ChildB1",
#'         type = "child"
#'       ),
#'       list(
#'         text = "ChildB2",
#'         type = "child"
#'       )
#'     )
#'   )
#' )
#'
#' types <- list(
#'   root = list(
#'     icon = "glyphicon glyphicon-ok"
#'   ),
#'   child = list(
#'     icon = "glyphicon glyphicon-file"
#'   )
#' )
#'
#' checkCallback <- JS(
#'   "function(operation, node, parent, position, more) {",
#'   "  if(operation === 'move_node') {",
#'   "    if(parent.id === '#' || parent.type === 'child') {",
#'   "      return false;", # prevent moving a child above or below the root
#'   "    }",               # and moving inside a child
#'   "  }",
#'   "  return true;", # allow everything else
#'   "}"
#' )
#'
#' dnd <- list(
#'   is_draggable = JS(
#'     "function(node) {",
#'     "  return node[0].type === 'child';",
#'     "}"
#'   )
#' )
#'
#' \donttest{jstree(
#'   nodes,
#'   dragAndDrop = TRUE, dnd = dnd,
#'   types = types,
#'   checkCallback = checkCallback
#' )}
#'
#'
#' # example illustrating the 'grid' option ####
#'
#' library(jsTreeR)
#'
#' nodes <- list(
#'   list(
#'     text = "Products",
#'     children = list(
#'       list(
#'         text = "Fruit",
#'         children = list(
#'           list(
#'             text = "Apple",
#'             data = list(
#'               price = 0.1,
#'               quantity = 20
#'             )
#'           ),
#'           list(
#'             text = "Banana",
#'             data = list(
#'               price = 0.2,
#'               quantity = 31
#'             )
#'           ),
#'           list(
#'             text = "Grapes",
#'             data = list(
#'               price = 1.99,
#'               quantity = 34
#'             )
#'           ),
#'           list(
#'             text = "Mango",
#'             data = list(
#'               price = 0.5,
#'               quantity = 8
#'             )
#'           ),
#'           list(
#'             text = "Melon",
#'             data = list(
#'               price = 0.8,
#'               quantity = 4
#'             )
#'           ),
#'           list(
#'             text = "Pear",
#'             data = list(
#'               price = 0.1,
#'               quantity = 30
#'             )
#'           ),
#'           list(
#'             text = "Strawberry",
#'             data = list(
#'               price = 0.15,
#'               quantity = 32
#'             )
#'           )
#'         ),
#'         state = list(
#'           opened = TRUE
#'         )
#'       ),
#'       list(
#'         text = "Vegetables",
#'         children = list(
#'           list(
#'             text = "Aubergine",
#'             data = list(
#'               price = 0.5,
#'               quantity = 8
#'             )
#'           ),
#'           list(
#'             text = "Broccoli",
#'             data = list(
#'               price = 0.4,
#'               quantity = 22
#'             )
#'           ),
#'           list(
#'             text = "Carrot",
#'             data = list(
#'               price = 0.1,
#'               quantity = 32
#'             )
#'           ),
#'           list(
#'             text = "Cauliflower",
#'             data = list(
#'               price = 0.45,
#'               quantity = 18
#'             )
#'           ),
#'           list(
#'             text = "Potato",
#'             data = list(
#'               price = 0.2,
#'               quantity = 38
#'             )
#'           )
#'         )
#'       )
#'     ),
#'     state = list(
#'       opened = TRUE
#'     )
#'   )
#' )
#'
#' grid <- list(
#'   columns = list(
#'     list(
#'       width = 200,
#'       header = "Name"
#'     ),
#'     list(
#'       width = 150,
#'       value = "price",
#'       header = "Price"
#'     ),
#'     list(
#'       width = 150,
#'       value = "quantity",
#'       header = "Qty"
#'     )
#'   ),
#'   width = 600
#' )
#'
#' jstree(nodes, grid = grid)
#'
#'
#' # example illustrating custom context menu ####
#'
#' library(jsTreeR)
#'
#' customMenu <- JS("function customMenu(node)
#' {
#'   var tree = $('#mytree').jstree(true);
#'   var items = {
#'     'rename' : {
#'       'label' : 'Rename',
#'       'action' : function (obj) { tree.edit(node); },
#'       'icon': 'glyphicon glyphicon-edit'
#'     },
#'     'delete' : {
#'       'label' : 'Delete',
#'       'action' : function (obj) { tree.delete_node(node); },
#'       'icon' : 'glyphicon glyphicon-trash'
#'     },
#'     'create' : {
#'       'label' : 'Create',
#'       'action' : function (obj) { tree.create_node(node); },
#'       'icon': 'glyphicon glyphicon-plus'
#'     }
#'   }
#'   return items;
#' }")
#'
#' nodes <- list(
#'   list(
#'     text = "RootA",
#'     children = list(
#'       list(
#'         text = "ChildA1"
#'       ),
#'       list(
#'         text = "ChildA2"
#'       )
#'     )
#'   ),
#'   list(
#'     text = "RootB",
#'     children = list(
#'       list(
#'         text = "ChildB1"
#'       ),
#'       list(
#'         text = "ChildB2"
#'       )
#'     )
#'   )
#' )
#'
#' \donttest{jstree(
#'   nodes, checkCallback = TRUE, elementId = "mytree",
#'   contextMenu = list(items = customMenu)
#' )}
jstree <- function(
  nodes, elementId = NULL,
  selectLeavesOnly = FALSE,
  checkboxes = FALSE,
  checkWithText = TRUE,
  search = FALSE, searchtime = 250,
  dragAndDrop = FALSE, dnd = NULL,
  multiple = TRUE,
  types = NULL,
  sort = FALSE,
  unique = FALSE,
  wholerow = FALSE,
  contextMenu = FALSE,
  checkCallback = NULL,
  grid = NULL,
  theme = "default"
){
  if(!isNodesList(nodes) && !isCallbackNodes(nodes)
     && !isAJAXnodes(nodes) && !isLAZYnodes(nodes)){
    stop(
      "Invalid `nodes` argument.", call. = TRUE
    )
  }
  if(isNodesList(nodes)){
    message("Populating tree using a list.")
  }else if(isCallbackNodes(nodes)){
    message("Populating tree using a callback function.")
  }else if(isLAZYnodes(nodes)){
    message("Populating tree using AJAX and lazy loading.")
  }else if(isAJAXnodes(nodes)){
    message("Populating tree using AJAX.")
  }
  stopifnot(is.null(elementId) || isString(elementId))
  stopifnot(isBoolean(selectLeavesOnly))
  stopifnot(isBoolean(checkboxes))
  stopifnot(isBoolean(checkWithText))
  stopifnot(isBoolean(search) || isNamedList(search))
  stopifnot(isBoolean(dragAndDrop))
  stopifnot(is.null(dnd) || isNamedList(dnd))
  stopifnot(is.logical(multiple))
  stopifnot(is.null(types) || isNamedList(types))
  stopifnot(isBoolean(unique))
  stopifnot(isBoolean(wholerow))
  stopifnot(is.logical(contextMenu) || isNamedList(contextMenu))
  stopifnot(
    is.null(checkCallback) || isTRUE(checkCallback) || isJS(checkCallback)
  )
  stopifnot(is.null(grid) || isNamedList(grid))
  stopifnot(isString(theme))
  # forward options using x
  x = list(
    data = nodes,
    selectLeavesOnly = selectLeavesOnly,
    checkbox = checkboxes,
    checkWithText = ifelse(checkboxes, checkWithText, TRUE),
    search = search,
    searchtime = searchtime,
    dragAndDrop = dragAndDrop,
    dnd = dnd,
    multiple = multiple,
    types = types,
    sort = sort,
    unique = unique,
    wholerow = wholerow,
    contextMenu = contextMenu,
    checkCallback = checkCallback %||% (dragAndDrop || contextMenu),
    grid = validateGrid(grid),
    theme = match.arg(theme, c("default", "default-dark", "proton"))
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'jstreer',
    x,
    width = NULL,
    height = NULL,
    package = 'jsTreeR',
    elementId = elementId,
    dependencies = list(
      jquery_core(major_version = 3, minified = TRUE),
      bootstrapLib(theme = NULL),
      htmlDependency(
        name = "jstree",
        version = "3.3.16",
        src = "htmlwidgets/lib/jstree/dist",
        script = "jstree.min.js",
        stylesheet = c(
          "themes/default/style.min.css", "themes/default-dark/style.min.css"
        ),
        package = "jsTreeR"
      ),
      htmlDependency(
        name = "jstreegrid",
        version = "3.10.1",
        src = "htmlwidgets/lib/jstreegrid",
        script = "jstreegrid.min.js",
        package = "jsTreeR"
      ),
      # htmltools::htmlDependency(
      #   name = "bootstrap",
      #   version = "3.4.1",
      #   src = "www/shared/bootstrap",
      #   stylesheet = "css/bootstrap.min.css",
      #   package = "shiny"
      # ),
      fa_html_dependency(),
      htmlDependency(
        name = "SuperTinyIcons",
        version = "0.4.0",
        src = "www/SuperTinyIcons",
        stylesheet = "SuperTinyIcons.css",
        package = "jsTreeR",
        all_files = TRUE
      ),
      htmlDependency(
        name = "OtherIcons",
        version = "0.0.1",
        src = "www/OtherIcons",
        stylesheet = "OtherIcons.css",
        package = "jsTreeR",
        all_files = TRUE
      )
    )
  )
}
