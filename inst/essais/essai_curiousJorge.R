library(jsTreeR)

nodes <- list(
  list(
    text = "Menu",
    state = list(opened = TRUE),
    a_attr = list(style = "font-weight: bold;"),
    children = list(
      list(
        text = "Dog",
        type = "moveable",
        state = list(disabled = TRUE),
        icon = "fas fa-dog"
      ),
      list(
        text = "Cat",
        type = "moveable",
        state = list(disabled = TRUE),
        icon = "fas fa-cat"
      ),
      list(
        text = "Fish",
        type = "moveable",
        state = list(disabled = TRUE),
        icon = "fas fa-fish"
      )
    )
  ),
  list(
    text = ">>> Drag here <<<",
    type = "target",
    state = list(opened = TRUE),
    a_attr = list(style = "font-weight: bold;")
  )
)

checkCallback <- JS(
  "function(operation, node, parent, position, more) { ",
  "  if(operation === 'copy_node') {",
  "    var n = parent.children.length;",
  "    if(position !== n || parent.id === '#' || node.parent !== 'j1_1' || parent.type !== 'target') {",
  "      return false;", # prevent moving an item above or below the root
  "    }",               # and moving inside an item except a 'target' item
  "  }",
  "  if(operation === 'delete_node') {",
  "    Shiny.setInputValue('deletion', position + 1);",
  "  }",
  "  return true;",      # allow everything else
  "}"
)

dnd <- list(
  always_copy = TRUE,
  inside_pos = "last",
  is_draggable = JS(
    "function(node) {",
    "  return node[0].type === 'moveable';",
    "}"
  )
)

customMenu <- JS(
  "function customMenu(node) {",
  "  var tree = $('#mytree').jstree(true);", # 'mytree' is the Shiny id or the elementId
  "  var items = {",
  "    'delete' : {",
  "      'label'  : 'Delete',",
  "      'action' : function (obj) { tree.delete_node(node); },",
  "      'icon'   : 'glyphicon glyphicon-trash'",
  "     }",
  "  }",
  "  return items;",
  "}")


mytree <- jstree(
  nodes, dragAndDrop = TRUE, dnd = dnd, checkCallback = checkCallback,
  types = list(moveable = list(), target = list()),
  contextMenu = list(items = customMenu),
  theme = "proton"
)

script <- '
$(document).ready(function(){
  var LETTERS = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
  var Visited = {};
  $("#mytree").on("copy_node.jstree", function(e, data){
    var oldid = data.original.id;
    var visited = Object.keys(Visited);
    if(visited.indexOf(oldid) === -1){
      Visited[oldid] = 0;
    }else{
      Visited[oldid]++;
    }
    var letter = LETTERS[Visited[oldid]];
    var node = data.node;
    var id = node.id;
    var index = $("#"+id).index() + 1;
    var text = index + ". " + node.text + " " + letter;
    Shiny.setInputValue("choice", text);
    var instance = data.new_instance;
    instance.rename_node(node, text);
  });
});
'

library(shiny)
ui <- fluidPage(
  tags$head(tags$script(HTML(script))),
  fluidRow(
    column(
      width = 4,
      jstreeOutput("mytree")
    ),
    column(
      width = 8,
      verbatimTextOutput("choices")
    )
  )
)

server <- function(input, output, session){

  output[["mytree"]] <- renderJstree(mytree)

  Choices <- reactiveVal(data.frame(choice = character(0)))

  observeEvent(input[["choice"]], {
    Choices(
      rbind(
        Choices(),
        data.frame(choice = input[["choice"]])
      )
    )
  })

  observeEvent(input[["deletion"]], {
    Choices(
      Choices()[-input[["deletion"]], , drop = FALSE]
    )
  })

  output[["choices"]] <- renderPrint({
    Choices()
  })

}

shinyApp(ui, server)




# browsable(
#   tagList(
#     jquerylib::jquery_core(),
#     mytree,
#     tags$script(HTML(script))
#   )
# )
