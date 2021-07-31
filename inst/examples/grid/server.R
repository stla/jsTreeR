shinyServer(
  function(input, output){
    output[["jstree"]] <-
      renderJstree(jstree(nodes, grid = grid, types = types))
  }
)
