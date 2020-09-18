function extractKeysWithChildren(list) {
  return {
    text: list.text,
    data: list.data,
    children: list.children.map(extractKeysWithChildren)
  };
}

function getNodesWithChildren(json) {
  return json.map(extractKeysWithChildren);
}

function extractKeys(list) {
  return {
    text: list.text,
    data: list.data
  };
}

function getNodes(json) {
  return json.map(extractKeys);
}


var inShiny = HTMLWidgets.shinyMode;


HTMLWidgets.widget({

  name: 'jstree',

  type: 'output',

  factory: function(el, width, height) {

    var $el = $(el);
    var options = {};
    var id = el.id + ":jsTreeR.list",
      id_selected = el.id + "_selected:jsTreeR.list",
      id_move = el.id + "_move:jsTreeR.move",
      id_rename = el.id + "_rename:jsTreeR.move",
      id_create = el.id + "_create";

    return {

      renderValue: function(x) {

        var plugins = ['themes'];
        if(x.checkbox) {
          plugins.push('checkbox');
        }
        if(x.search) {
          plugins.push('search');
        }
        if(x.dragAndDrop) {
          plugins.push('dnd');
        }
        if(x.types) {
          plugins.push('types');
        }
        if(x.unique) {
          plugins.push('unique');
        }
        if(x.sort) {
          plugins.push('sort');
        }
        if(x.wholerow) {
          plugins.push('wholerow');
        }
        if(x.contextMenu) {
          plugins.push('contextmenu');
        }
        if(x.grid) {
          plugins.push('grid');
        }
        options.plugins = plugins;

        options.core = {
          'data': x.data,
          'multiple': x.multiple,
          'check_callback': x.checkCallback,
          'themes': {
            'name': x.theme,
            'icons': true,
            'dots': true,
            'responsive': true
          }
        };

        if(x.types)
          options.types = x.types;

        if(x.dnd)
          options.dnd = x.dnd;

        if(x.grid)
          options.grid = x.grid;

        if(x.checkbox)
          options.checkbox = {
            'keep_selected_style': false
          };

        if(typeof x.search !== "boolean")
          options.search = x.search;

        if(typeof x.contextMenu !== "boolean") {
          options.contextmenu = x.contextMenu;
        } else {
          options.contextmenu = {
            select_node: false
          };
        }

        $el.jstree(options);



        $el.on("ready.jstree", function(e, data) {
          if(x.search) {
            var $input =
              $("<input type='search' id='" + el.id + "-search' placeholder='Search' />");
            $input.insertBefore($el);
            $input.on("keyup", function() {
              $el.jstree(true).search($(this).val());
            });
          }
          if(inShiny) {
            Shiny.setInputValue(
              id, getNodesWithChildren(data.instance.get_json())
            );
            Shiny.setInputValue(
              id_selected, getNodes(data.instance.get_selected(true))
            );
          }
        });

        $el.on("move_node.jstree", function(e, data) {
          if(inShiny) {
            var instance = data.instance;
            var node = data.node;
            var nodeText = node.text;
            var oldPath = instance.get_path(data.old_parent).concat([nodeText]);
            var newPath = instance.get_path(node);
            Shiny.setInputValue(
              id_move, {from: oldPath, to: newPath}
            );
            Shiny.setInputValue(
              id, getNodesWithChildren(instance.get_json())
            );
          }
        });

        $el.on("changed.jstree", function(e, data) {
          if(inShiny) {
//            Shiny.setInputValue(
//              id, getNodesWithChildren(data.instance.get_json())
//            );
            Shiny.setInputValue(
              id_selected, getNodes(data.instance.get_selected(true))
            );
          }
        });

        $el.on("rename_node.jstree", function(e, data) {
          if(inShiny)
            var instance = data.instance;
            var parentPath = instance.get_path(data.node.parent);
            var oldPath = parentPath.concat(data.old);
            var newPath = parentPath.concat(data.text);
            Shiny.setInputValue(
              id_rename, {from: oldPath, to: newPath}
            );
            Shiny.setInputValue(
              id, getNodesWithChildren(instance.get_json())
            );
            Shiny.setInputValue(
              id_selected, getNodes(instance.get_selected(true))
            );
        });

        $el.on("create_node.jstree", function(e, data) {
          if(inShiny) {
            var instance = data.instance;
/*            Shiny.setInputValue(
              id_create, instance.get_path(data.node)
            );*/
            Shiny.setInputValue(
              id, getNodesWithChildren(instance.get_json())
            );
          }
        });

        $el.on("paste.jstree", function(e, data) {
          if(inShiny)
            Shiny.setInputValue(
              id, getNodesWithChildren(data.instance.get_json())
            );
        });

        $el.on("delete_node.jstree", function(e, data) {
          if(inShiny)
            Shiny.setInputValue(
              id, getNodesWithChildren(data.instance.get_json())
            );
        });

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
