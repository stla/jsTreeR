library(jsTreeR)

jstree(
  nodes = JS('
  function (node, cb) {
    if(node.id === "#") {
      cb([{"text" : "Root", "id" : "1", "children" : true}]);
    } else {
      cb(["Child"]);
    }
  }')
)
