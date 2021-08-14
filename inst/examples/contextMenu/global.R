library(shiny)
library(jsTreeR)

customMenu <- JS("function customMenu(node)
{
  var tree = $('#mytree').jstree(true);
  var items = {
    'rename' : {
      'label' : 'Rename',
      'action' : function (obj) { tree.edit(node); },
      'icon': 'glyphicon glyphicon-edit'
    },
    'delete' : {
      'label' : 'Delete',
      'action' : function (obj) { tree.delete_node(node); },
      'icon' : 'glyphicon glyphicon-trash'
    },
    'create' : {
      'label' : 'Create',
      'action' : function (obj) { tree.create_node(node); },
      'icon': 'glyphicon glyphicon-plus'
    }
  }
  return items;
}")

nodes <- list(
  list(
    text = "RootA",
    children = list(
      list(
        text = "ChildA1"
      ),
      list(
        text = "ChildA2"
      )
    )
  ),
  list(
    text = "RootB",
    children = list(
      list(
        text = "ChildB1"
      ),
      list(
        text = "ChildB2"
      )
    )
  )
)
