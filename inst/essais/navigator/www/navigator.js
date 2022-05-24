var tree;

$(document).ready(function () {
  var Children = null;

  Shiny.addCustomMessageHandler("getChildren", function (x) {
    Children = x;
  });

  $("#navigator").on("click", "li.jstree-x > i", function (e) {
    var $li = $(this).parent();
    if (!$li.hasClass("jstree-x")) {
      alert("that should not happen...");
      return;
    }
    var id = $li.attr("id");
    var node = tree.get_node(id);
    if (tree.is_leaf(node) && node.original.type === "folder") {
      var path = tree.get_path(node, "/");
      Shiny.setInputValue("path", path);
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
