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


jstree( # does not work in RStudio viewer
  nodes = list(
    url = "https://www.jstree.com/fiddle/",
    dataType = "json"
  )
)


jstree( # does not work in RStudio viewer
  nodes = list(
    url = "https://www.jstree.com/fiddle/?lazy",
    data = JS('function(node){return { "id" : node.id };}')
  )
)
