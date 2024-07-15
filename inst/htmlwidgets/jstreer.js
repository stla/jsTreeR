function filterChecked0(instance, list, keys) {
  var out = {};
  keys.forEach(function(k) {
    out[k] = list[k];
  });
  var children = list.children.map(function(child) {
    var id = child.id;
    var checked = instance.get_checked_descendants(id);
    if(checked.length > 0) {
      return filterChecked0(instance, child, keys);
    }
    if(instance.is_leaf(id) && instance.is_checked(id)) {
      return extractKeys(child);
    }
    return;
  });
  out.children = children.filter(function(x) {return x !== undefined});
  return out;
}

function filterChecked(instance, keys) {
  if(instance.get_checked_descendants("#").length === 0) {
    return {};
  }
  var lists = instance.get_json().filter(function(x) {
    return instance.get_checked_descendants(x.id).length !== 0
  });
  return lists.map(function(x) {
    return filterChecked0(instance, x, keys);
  });
}

function extractKeysWithChildren(list, keys) {
  var out = {};
  keys.forEach(function(k) {
    out[k] = list[k];
  });
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
    type: list.type,
    children: list.children
  };
}

function getNodes(json) {
  return json.map(extractKeys);
}

function fullTree0(instance, node) {
  node.state.undetermined = instance.is_undetermined(node);
  node.children.map(function(child) { fullTree0(instance, child); });
}

function setShinyValue(instance, checkboxes) {
  Shiny.setInputValue(
    instance.element.attr("id") + ":jsTreeR.list",
    getNodesWithChildren(instance.get_json(), ["text", "data"])
  );
  var fulltree = instance.get_json();
  if(checkboxes) {
    fulltree.map(function(node) { fullTree0(instance, node); });
  }
  Shiny.setInputValue(
    instance.element.attr("id") + "_full:jsTreeR.list",
    fulltree
  );
}

function setShinyValueSelectedNodes(instance, leavesOnly, checkboxes) {
  var selectedNodes = instance.get_selected(true);
  var nodes = getNodes(selectedNodes);
  var leaves = [];
  var pathNodes = [];
  var leavePathNodes = [];
  for(var i = 0; i < nodes.length; i++) {
    var node = nodes[i];
    var path = instance.get_path(selectedNodes[i], "/");
    var pathNode = {
      path: path,
      data: node.data
    };
    pathNodes.push(pathNode);
    var hasChildren = node.children;
    var nchildren = hasChildren ? node.children.length : 0;
    if(hasChildren) {
      delete nodes[i].children;
    }
    if(leavesOnly && nchildren === 0) {
      leaves.push(nodes[i]);
      leavePathNodes.push(pathNode);
    }
  }
  Shiny.setInputValue(
    instance.element.attr("id") + "_selected:jsTreeR.list",
    leavesOnly ? leaves : nodes
  );
  Shiny.setInputValue(
    instance.element.attr("id") + "_selected_paths:jsTreeR.list",
    leavesOnly ? leavePathNodes : pathNodes
  );
  if(checkboxes){
    Shiny.setInputValue(
      instance.element.attr("id") + "_checked_tree:jsTreeR.list",
      filterChecked(instance, ["text", "data", "type"])
    );
  }
}

function setShinyValueCheckedNodes(instance, leavesOnly) {
  var checkedNodes = instance.get_checked(true);
  var nodes = getNodes(checkedNodes);
  var leaves = [];
  var pathNodes = [];
  var leavePathNodes = [];
  for(var i = 0; i < nodes.length; i++) {
    var node = nodes[i];
    var path = instance.get_path(checkedNodes[i], "/");
    var pathNode = {
      path: path,
      data: node.data
    };
    pathNodes.push(pathNode);
    var hasChildren = node.children;
    var nchildren = hasChildren ? node.children.length : 0;
    if(hasChildren) {
      delete nodes[i].children;
    }
    if(leavesOnly && nchildren === 0) {
      leaves.push(nodes[i]);
      leavePathNodes.push(pathNode);
    }
  }
  Shiny.setInputValue(
    instance.element.attr("id") + "_checked:jsTreeR.list",
    leavesOnly ? leaves : nodes
  );
  Shiny.setInputValue(
    instance.element.attr("id") + "_checked_paths:jsTreeR.list",
    leavesOnly ? leavePathNodes : pathNodes
  );
}

function gridSearchBox(index, id) {
  var input =
    `<input type="text" placeholder="Search..." name="${index}" value=""` +
    `style="width: calc(100% - 2px);" class="${id}-searchField">`;
  return input;
}


var inShiny = HTMLWidgets.shinyMode;

HTMLWidgets.widget({
  name: "jstreer",

  type: "output",

  factory: function(el, width, height) {
    var $el = $(el);
    var options = {};

    return {
      renderValue: function(x) {

        if($el.hasClass("jstree")) {
          $("#" + el.id + "-search").remove();
          $el.jstree(true).destroy();
        }

        var plugins = ["themes"];
        if(x.checkbox) {
          plugins.push("checkbox");
        }
        if(x.search) {
          plugins.push("search");
        }
        if(x.dragAndDrop) {
          plugins.push("dnd");
        }
        if(x.types) {
          plugins.push("types");
        }
        if(x.unique) {
          plugins.push("unique");
        }
        if(x.sort) {
          plugins.push("sort");
        }
        if(x.wholerow) {
          plugins.push("wholerow");
        }
        if(x.contextMenu) {
          plugins.push("contextmenu");
        }
        if(x.grid) {
          plugins.push("grid");
        }
        options.plugins = plugins;

        options.core = {
          data: x.data,
          multiple: x.multiple,
          check_callback: x.checkCallback,
          themes: {
            name: x.theme,
            icons: true,
            dots: true,
            responsive: false
          }
        };

        $.extend(options.core, x.coreOptions);

        if(x.types) options.types = x.types;

        if(x.dnd) options.dnd = x.dnd;

        if(x.grid) options.grid = x.grid;

        if(x.checkbox)
          options.checkbox = {
            keep_selected_style: !x.checkWithText,
            cascade_to_disabled: false,
            tie_selection: x.checkWithText,
            whole_node: x.checkWithText
            //three_state: false,
            //cascade: "up+undetermined"
          };

        if(typeof x.search !== "boolean") options.search = x.search;

        if(typeof x.contextMenu !== "boolean") {
          options.contextmenu = x.contextMenu;
        } else if(x.contextMenu) {
          options.contextmenu = {
            select_node: false
          };
        }

        var leavesOnly = x.selectLeavesOnly;
        var checkboxes = x.checkbox;

        $el.jstree(options);

        $el.on("ready.jstree", function(e, data) {
          if(x.search) {
            if(x.grid) {

              var ncolumns = x.grid.columns.length;
              for(var i = 0; i < ncolumns; i++) {
                var columnRoot = ".jstree-grid-column-" + i +
                  ".jstree-grid-column-root-" + el.id;
                var $header = $(columnRoot).children(".jstree-grid-header")
                var $searchBox = $(gridSearchBox(i, el.id));
                $header.after($searchBox)
              }

              var $searchBoxesSelector = $("." + el.id + "-searchField");
              //add search functionality to the input fields
              $searchBoxesSelector.keyup(function(e) {
            	//get all input fields
                var $searchFields = $searchBoxesSelector;
                var searchValues = {};
                //create for each input a key value pair with the key in the
                //  name attribute of the input (also being the column index)
                $searchFields.each(function() {
                  var field = $(this);
                  searchValues[field.attr("name")] = field.val();
                });
                //use the new searchColumn method
                $el.jstree(true).searchColumn(searchValues);
              });
            } else {
              var $input = $(
                "<input type='search' id='" +
                  el.id +
                  "-search' placeholder='Search' />"
              );
              $input.insertBefore($el);
              $input.on("keyup", function() {
                $el.jstree(true).search($(this).val());
              });
            }
          }
/*          $el.on("click", ".jstree-anchor", function(evt) {
            alert("CLICK");
            console.log(evt);
            if(!x.checkWithText && !($(evt.target).hasClass("jstree-checkbox"))) {
              evt.stopPropagation();
            }
          }); */
          if(inShiny) {
            setShinyValue(data.instance, checkboxes);
            setShinyValueSelectedNodes(data.instance, leavesOnly, checkboxes);
            if(checkboxes) {
              setShinyValueCheckedNodes(data.instance, leavesOnly);
            }
          }
        });

        $el.on("refresh.jstree", function(e, data) {
          if(inShiny) {
            setShinyValue(data.instance, checkboxes);
            setShinyValueSelectedNodes(data.instance, leavesOnly, checkboxes);
            if(checkboxes) {
              setShinyValueCheckedNodes(data.instance, leavesOnly);
            }
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
            var oldPath = oldInstance
              .get_path(data.old_parent)
              .concat(nodeText);
            Shiny.setInputValue("jsTreeMoved:jsTreeR.copied", {
              from: { instance: oldInstanceId, path: oldPath },
              to: { instance: newInstanceId, path: newPath }
            }, {priority: "event"});
            if(data.is_multi) { // ??
              setShinyValue(oldInstance, checkboxes);
              setShinyValue(newInstance, checkboxes);
            } else {
              setShinyValue(data.instance, checkboxes);
            }
          }
        });

        $el.on("changed.jstree", function(e, data) {
          if(inShiny) {
            //            Shiny.setInputValue(
            //              id, getNodesWithChildren(data.instance.get_json())
            //            );
            setShinyValueSelectedNodes(data.instance, leavesOnly, checkboxes);
            if(checkboxes) {
              setShinyValueCheckedNodes(data.instance, leavesOnly);
            }
            setShinyValue(data.instance);
          }
        });

        $el.on("after_open.jstree", function(e, data) {
          if(inShiny) {
            setShinyValue(data.instance, checkboxes);
          } // modif 9/10/2023
        });

        $el.on("after_close.jstree", function(e, data) {
          if(inShiny) {
            setShinyValue(data.instance, checkboxes);
          } // modif 9/10/2023
        });

/*
         $el.on("select_node.jstree", function(e, data) {
           if(inShiny) {
             setShinyValue(data.instance, checkboxes);
           } // modif 9/10/2023
         });

         $el.on("deselect_node.jstree", function(e, data) {
           if(inShiny) {
             setShinyValue(data.instance, checkboxes);
           } // modif 9/10/2023
         });
*/

        if(!x.checkWithText) {
          $el.on("check_node.jstree", function(e, data) {
            $el.jstree(true).select_node(data.node);
            if(inShiny) {
              setShinyValue(data.instance, checkboxes);
              setShinyValueSelectedNodes(data.instance, leavesOnly, checkboxes);
              if(checkboxes) {
                setShinyValueCheckedNodes(data.instance, leavesOnly);
              }
            }
          });
          $el.on("uncheck_node.jstree", function(e, data) {
            $el.jstree(true).deselect_node(data.node);
            if(inShiny) {
              setShinyValue(data.instance, checkboxes);
              setShinyValueSelectedNodes(data.instance, leavesOnly, checkboxes);
              if(checkboxes) {
                setShinyValueCheckedNodes(data.instance, leavesOnly);
              }
            }
          });
        }

        $el.on("rename_node.jstree", function(e, data) {
          if(inShiny) {
            var instance = data.instance;
            var parentPath = instance.get_path(data.node.parent) || [];
            var oldPath = parentPath.concat(data.old);
            var newPath = parentPath.concat(data.text);
            Shiny.setInputValue("jsTreeRenamed:jsTreeR.move", {
              instance: instance.element.attr("id"),
              from: oldPath,
              to: newPath
            });
            setShinyValue(instance, checkboxes);
            setShinyValueSelectedNodes(instance, leavesOnly, checkboxes);
            if(checkboxes) {
              setShinyValueCheckedNodes(data.instance, leavesOnly);
            }
          }
        });

        $el.on("create_node.jstree", function(e, data) {
          if(inShiny) {
            var instance = data.instance;
            Shiny.setInputValue("jsTreeCreated:jsTreeR.path", {
              instance: instance.element.attr("id"),
              path: instance.get_path(data.node),
              node: extractKeys(instance.get_json(data.node))
            });
            setShinyValue(instance, checkboxes);
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
            Shiny.setInputValue("jsTreeCopied:jsTreeR.copied", {
              from: { instance: oldInstanceId, path: oldPath },
              to: { instance: newInstanceId, path: newPath }
            }, {priority: "event"});
            setShinyValue(newInstance, checkboxes);
          }
        });

        $el.on("delete_node.jstree", function(e, data) {
          if(inShiny) {
            var instance = data.instance;
            Shiny.setInputValue("jsTreeDeleted:jsTreeR.path", {
              instance: instance.element.attr("id"),
              path: instance.get_path(data.node)
            }, {priority: "event"});
            setShinyValue(instance, checkboxes);
          }
        });

        if(inShiny) {

          var id = el.id;

          Shiny.addCustomMessageHandler(id + "_destroy", function(nothing) {
            try {
              $("#" + id + "-search").remove();
              $el.jstree(true).destroy();
            } catch(err) {
              console.warn(
                "An error occured."
              );
            }
          });

          Shiny.addCustomMessageHandler(id + "_update", function(newnodes) {
            try {
              var $search = $("#" + id + "-search");
              if($search.length > 0) {
                $search.val("");
              }
              $el.jstree(true).settings.core.data = newnodes;
              $el.jstree(true).refresh(true, true);
            } catch(err) {
              console.warn(
                "An error occured."
              );
            }
          });

        }


      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
