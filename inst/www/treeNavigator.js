$(document).ready(function () {
  var tree;

  var Children = null;

  Shiny.addCustomMessageHandler("getChildren", function (x) {
    Children = x;
  });

  $navigator = $("#navigator");

  $navigator.one("ready.jstree", function (e, data) {
    tree = data.instance;
    tree.disable_checkbox("j1_1"); // pb si plusieurs navigateurs
    tree.disable_node("j1_1");
  });

  $navigator.on("after_open.jstree", function (e, data) {
    tree.enable_checkbox(data.node);
    tree.enable_node(data.node);
  });

  $navigator.on("after_close.jstree", function (e, data) {
    tree.disable_checkbox(data.node);
    tree.disable_node(data.node);
  });

  $navigator.on("click", "li.jstree-x > i", function (e) {
    var $li = $(this).parent();
    if (!$li.hasClass("jstree-x")) {
      alert("that should not happen...");
      return;
    }
    var id = $li.attr("id");
    var node = tree.get_node(id);
    if (tree.is_leaf(node) && node.original.type === "folder") {
      var path = tree.get_path(node, "/");
      Shiny.setInputValue("path_from_js", path);
      var interval = setInterval(function () {
        if (Children !== null) {
          clearInterval(interval);
          for (var i = 0; i < Children.elem.length; i++) {
            var isdir = Children.folder[i];
            var newnode = tree.create_node(id, {
              text: Children.elem[i],
              type: isdir ? "folder" : "file",
              children: false,
              li_attr: isdir ? { class: "jstree-x" } : null
            });
            if (isdir) {
              tree.disable_checkbox(newnode);
              tree.disable_node(newnode);
            }
          }
          Children = null;
          setTimeout(function () {
            tree.open_node(id);
          }, 10);
        }
      }, 100);
    }
  });
});
