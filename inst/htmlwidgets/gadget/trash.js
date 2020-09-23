function getChildByText(parent, text) {
  var texts = parent.children.map(function(child) {
    return child.text;
  });
  var index = texts.indexOf(text);
  if(index > -1) {
    return parent.children[index];
  } else {
    return null;
  }
}

function restoreNode(tree, path, nodeAsJSON) {
  path = path.slice();
  path.shift();
  var parent = getNodesWithChildren(tree.get_json(), ["text", "id"])[0];
  var head = path.shift();
  var child = getChildByText(parent, head);
  while(child !== null && path.length > 0) {
    parent = child;
    head = path.shift();
    child = getChildByText(parent, head);
  }
  path = [head].concat(path);
  var id = parent.id;
  for(var i = 0; i < path.length - 1; i++) {
    id = tree.create_node(id, { text: path[i], type: "folder" });
  }
  tree.create_node(id, nodeAsJSON);
}

function restore(treeId, path, nodeAsJSON, id) {
  var tree = $("#" + treeId).jstree(true);
  restoreNode(tree, path, nodeAsJSON);
  var trashTree = $("#trash").jstree(true);
  trashTree.delete_node(id);
  var type = nodeAsJSON.type === "folder" ? "folder" : "file";
  Shiny.setInputValue("restore", {
    instance: treeId,
    path: path.join(sep),
    type: type
  });
}

function addTrashItem(treeId, path, nodeAsJSON) {
  var id = "node" + Math.random().toFixed(15).replace(".", "_");
  var onclick =
    "var d = $(this).data(); restore(d.instance, d.path, d.node, d.id)";
  var attrs =
    "class='btn btn-success btn-sm btn-restore' " +
    `data-instance='${treeId}' ` +
    `data-path='${JSON.stringify(path)}' ` +
    `data-node='${JSON.stringify(nodeAsJSON)}' ` +
    `data-id='${id}' ` +
    `onclick='${onclick}'`;
  var btn = `<button ${attrs}>restore</button>`;
  var trashTree = $("#trash").jstree(true);
  var node = {
    id: id,
    text: nodeAsJSON.text,
    type: nodeAsJSON.type,
    data: { button: btn },
    li_attr: { title: path.join(sep) }
  };
  trashTree.create_node("trash-" + treeId, node);
}
