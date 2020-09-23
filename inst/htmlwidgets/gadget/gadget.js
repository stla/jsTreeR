var copiedNode = null;

function fileExtension(fileName) {
  if(/\./.test(fileName)) {
    var splitted = fileName.split(".");
    return splitted[splitted.length - 1].toLowerCase();
  } else {
    return null;
  }
}

function isImage(ext) {
  return imageExts.indexOf(ext) > -1;
}

function item_pdf(tree, node) {
  return {
    PDF: {
      separator_before: true,
      separator_after: true,
      label: "View PDF",
      action: function(obj) {
        Shiny.setInputValue("viewPDF", {
          instance: tree.element.attr("id"),
          path: tree.get_path(node, sep)
        });
      }
    }
  };
}

function item_rerun(tree, node) {
  return {
    Rerun: {
      separator_before: true,
      separator_after: true,
      label: "Explore here",
      action: function(obj) {
        Shiny.setInputValue("rerun", {
          instance: tree.element.attr("id"),
          path: tree.get_path(node, sep)
        });
      }
    }
  };
}

function item_image(tree, node, ext) {
  return {
    Image: {
      separator_before: true,
      separator_after: true,
      label: "View image",
      action: function(obj) {
        Shiny.setInputValue("viewImage", {
          instance: tree.element.attr("id"),
          path: tree.get_path(node, sep),
          ext: ext
        });
      }
    }
  };
}

function Items(tree, node, paste) {
  return {
    Copy: {
      separator_before: true,
      separator_after: false,
      label: "Copy",
      action: function(obj) {
        tree.copy(node);
        copiedNode = { node: node, operation: "copy" };
      }
    },
    Cut: {
      separator_before: false,
      separator_after: !paste,
      label: "Cut",
      action: function(obj) {
        tree.cut(node);
        copiedNode = { instance: tree, node: node, operation: "cut" };
      }
    },
    Paste: paste
      ? {
          separator_before: false,
          separator_after: true,
          label: "Paste",
          _disabled: copiedNode === null,
          action: function(obj) {
            var children = tree.get_node(node).children.map(function(child) {
              return tree.get_text(child);
            });
            if(children.indexOf(copiedNode.node.text) === -1) {
              var operation = copiedNode.operation;
              tree.copy_node(copiedNode.node, node, 0, function() {
                Shiny.setInputValue("operation", operation);
                setTimeout(function() {
                  Shiny.setInputValue("operation", "rename");
                }, 0);
              });
              if(operation === "cut") {
                copiedNode.instance.delete_node(copiedNode.node);
              }
              copiedNode = null;
            }
          }
        }
      : null,
    Rename: {
      separator_before: true,
      separator_after: false,
      label: "Rename",
      action: function(obj) {
        tree.edit(node, null, function() {
          var nodeType = tree.get_type(node);
          if(nodeType === "file" || exts.indexOf(nodeType) > -1) {
            var nodeText = tree.get_text(node);
            var ext = fileExtension(nodeText);
            if(ext !== null) {
              if(exts.indexOf(ext) > -1) {
                tree.set_type(node, ext);
              } else {
                tree.set_type(node, "file");
              }
            }
          }
        });
      }
    },
    Remove: {
      separator_before: false,
      separator_after: true,
      label: "Remove",
      action: function(obj) {
        if(Trash) {
          addTrashItem(
            tree.element.attr("id"),
            tree.get_path(node),
            extractKeysWithChildren(tree.get_json(node), ["text", "type"])
          );
        }
        tree.delete_node(node);
      }
    }
  };
}

function items_file(tree, node) {
  return {
    Open: {
      separator_before: true,
      separator_after: false,
      label: "Open in RStudio",
      action: function(obj) {
        Shiny.setInputValue("openFile", {
          instance: tree.element.attr("id"),
          path: tree.get_path(node, sep)
        });
      }
    },
    Edit: {
      separator_before: false,
      separator_after: true,
      label: "Edit",
      action: function(obj) {
        Shiny.setInputValue(
          "editFile",
          { instance: tree.element.attr("id"), path: tree.get_path(node, sep) },
          { priority: "event" }
        );
      }
    }
  };
}

function item_create(tree, node) {
  return {
    Create: {
      separator_before: true,
      separator_after: true,
      label: "Create",
      action: false,
      submenu: {
        File: {
          separator_before: true,
          separator_after: false,
          label: "File",
          action: function(obj) {
            var children = tree.get_node(node).children.map(function(child) {
              return tree.get_text(child);
            });
            node = tree.create_node(node, { type: "file" });
            tree.edit(node, null, function() {
              var nodeText = tree.get_text(node);
              if(children.indexOf(nodeText) > -1) {
                tree.delete_node(node);
              } else {
                if(/\./.test(nodeText)) {
                  var splitted = nodeText.split(".");
                  var ext = splitted[splitted.length - 1].toLowerCase();
                  if(exts.indexOf(ext) > -1) {
                    tree.set_type(node, ext);
                  }
                }
                Shiny.setInputValue("createdNode", {
                  instance: tree.element.attr("id"),
                  type: "file",
                  path: tree.get_path(node, sep)
                });
              }
            });
          }
        },
        Folder: {
          separator_before: false,
          separator_after: true,
          label: "Folder",
          action: function(obj) {
            var children = tree.get_node(node).children.map(function(child) {
              return tree.get_text(child);
            });
            node = tree.create_node(node, { type: "folder" });
            tree.edit(node, null, function() {
              if(children.indexOf(tree.get_text(node)) > -1) {
                tree.delete_node(node);
              } else {
                Shiny.setInputValue("createdNode", {
                  instance: tree.element.attr("id"),
                  type: "folder",
                  path: tree.get_path(node, sep)
                });
              }
            });
          }
        }
      }
    }
  };
}
