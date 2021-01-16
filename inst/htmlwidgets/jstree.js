function extractKeysWithChildren(list, keys) {
  var out = {};
  keys.forEach(function(k) {out[k] = list[k]});
  out.children = list.children.map(function(child) {
    return extractKeysWithChildren(child, keys);
  });
  return out;
}

function getNodesWithChildren(json, keys) {
  return json.map(function(list) {
    return extractKeysWithChildren(list, keys);
  });
}

function extractKeys(list) {
  return {
    text: list.text,
    data: list.data,
    type: list.type
  };
}

function getNodes(json) {
  return json.map(extractKeys);
}

function setShinyValue(instance) {
  Shiny.setInputValue(
    instance.element.attr("id") + ":jsTreeR.list",
    getNodesWithChildren(instance.get_json(), ["text","data"])
  );
  Shiny.setInputValue(
    instance.element.attr("id") + "_full:jsTreeR.list",
    instance.get_json()
  );
}

function setShinyValueSelectedNodes(instance) {
  Shiny.setInputValue(
    instance.element.attr("id") + "_selected:jsTreeR.list",
    getNodes(instance.get_selected(true))
  );
}

var inShiny = HTMLWidgets.shinyMode;


HTMLWidgets.widget({

  name: 'jstree',

  type: 'output',

  factory: function(el, width, height) {

    var $el = $(el);
    var options = {};

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
            'responsive': false
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
        } else if(x.contextMenu) {
          options.contextmenu = {
            select_node: false
          };
        }

        $el.jstree(options);



        $el.on("ready.jstree", function(e, data) {
          if(x.search) {
            var $input = $("<input type='search' id='" + el.id
              + "-search' placeholder='Search' />");
            $input.insertBefore($el);
            $input.on("keyup", function() {
              $el.jstree(true).search($(this).val());
            });
          }
          if(inShiny) {
            setShinyValue(data.instance);
            setShinyValueSelectedNodes(data.instance);
          }
        });

        $el.on("move_node.jstree", function(e, data) {
          if(inShiny) {
            var newInstance = data.new_instance;
            var oldInstance = data.old_instance;
            var newInstanceId = newInstance.element.attr("id");
            var oldInstanceId = oldInstance.element.attr("id");
            var node = data.node;
            var nodeText = node.text;
            var newPath = newInstance.get_path(node);
            var oldPath =
              oldInstance.get_path(data.old_parent).concat(nodeText);
            Shiny.setInputValue(
              "jsTreeMoved:jsTreeR.copied", {
                from: {instance: oldInstanceId, path: oldPath},
                to: {instance: newInstanceId, path: newPath}
              }
            );
            if(data.is_multi) {
              setShinyValue(oldInstance);
              setShinyValue(newInstance);
            } else {
              setShinyValue(data.instance);
            }
          }
        });

        $el.on("changed.jstree", function(e, data) {
          if(inShiny) {
//            Shiny.setInputValue(
//              id, getNodesWithChildren(data.instance.get_json())
//            );
            setShinyValueSelectedNodes(data.instance);
          }
        });

        $el.on("rename_node.jstree", function(e, data) {
          if(inShiny) {
            var instance = data.instance;
            var parentPath = instance.get_path(data.node.parent);
            var oldPath = parentPath.concat(data.old);
            var newPath = parentPath.concat(data.text);
            Shiny.setInputValue(
              "jsTreeRenamed:jsTreeR.move", {
                instance: instance.element.attr("id"),
                from: oldPath,
                to: newPath
              }
            );
            setShinyValue(instance);
            setShinyValueSelectedNodes(instance);
          }
        });

        $el.on("create_node.jstree", function(e, data) {
          if(inShiny) {
            var instance = data.instance;
            Shiny.setInputValue(
              "jsTreeCreated:jsTreeR.path", {
                instance: instance.element.attr("id"),
                path: instance.get_path(data.node),
                node: extractKeys(instance.get_json(data.node))
              }
            );
            setShinyValue(instance);
          }
        });

        $el.on("copy_node.jstree", function(e, data) {
          if(inShiny) {
            var newInstance = data.new_instance;
            var oldInstance = data.old_instance;
            var newInstanceId = newInstance.element.attr("id");
            var oldInstanceId = oldInstance.element.attr("id");
            var newPath = newInstance.get_path(data.node);
            var oldPath = oldInstance.get_path(data.original);
            Shiny.setInputValue(
              "jsTreeCopied:jsTreeR.copied", {
                from: {instance: oldInstanceId, path: oldPath},
                to: {instance: newInstanceId, path: newPath}
              }
            );
            setShinyValue(newInstance);
          }
        });

        $el.on("delete_node.jstree", function(e, data) {
          if(inShiny) {
            var instance = data.instance;
            Shiny.setInputValue(
              "jsTreeDeleted:jsTreeR.path", {
                instance: instance.element.attr("id"),
                path: instance.get_path(data.node)
              }
            );
            setShinyValue(instance);
          }
        });

      },


      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
