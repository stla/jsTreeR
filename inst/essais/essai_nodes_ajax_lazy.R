library(jsTreeR)

jstree(
  nodes = list(
    url = "https://www.jstree.com/fiddle/?lazy",
    data = JS('function(node){return { "id" : node.id };}')
  )
)
