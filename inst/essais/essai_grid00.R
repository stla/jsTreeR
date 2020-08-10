library(jsTreeR)
library(jsonlite)

nodes <- fromJSON("./inst/essais/grid_nodes.js", simplifyDataFrame = FALSE)

grid <- fromJSON("./inst/essais/grid_grid.json", simplifyDataFrame = FALSE)

jstree(
  nodes,
  grid = grid
)


list(columns = list(list(width = 200L, header = "Name"), list(
  width = 150L, value = "price", header = "Price"),
  list(width = 150L, value = "quantity", header = "Qty")), width = 600L)

nodes <- list(
  list(
    text = "Products",
    children = list(
      list(
        text = "Fruit",
        children = list(
          list(
            text = "Apple",
            data = list(
              price = 0.1,
              quantity = 20
            )
          ),
          list(
            text = "Banana",
            data = list(
              price = 0.2,
              quantity = 31
            )
          ),
          list(
            text = "Grapes",
            data = list(
              price = 1.99,
              quantity = 34
            )
          ),
          list(
            text = "Mango",
            data = list(
              price = 0.5,
              quantity = 8
            )
          ),
          list(
            text = "Melon",
            data = list(
              price = 0.8,
              quantity = 4
            )
          ),
          list(
            text = "Pear",
            data = list(
              price = 0.1,
              quantity = 30
            )
          ),
          list(
            text = "Strawberry",
            data = list(
              price = 0.15,
              quantity = 32
            )
          )
        ),
        state = list(
          opened = TRUE
        )
      ),
      list(
        text = "Vegetables",
        children = list(
          list(
            text = "Aubergine",
            data = list(
              price = 0.5,
              quantity = 8
            )
          ),
          list(
            text = "Broccoli",
            data = list(
              price = 0.4,
              quantity = 22
            )
          ),
          list(
            text = "Carrot",
            data = list(
              price = 0.1,
              quantity = 32
            )
          ),
          list(
            text = "Cauliflower",
            data = list(
              price = 0.45,
              quantity = 18
            )
          ),
          list(
            text = "Potato",
            data = list(
              price = 0.2,
              quantity = 38
            )
          )
        )
      )
    ),
    state = list(
      opened = TRUE
    )
  )
)

grid <- list(
  columns = list(
    list(
      width = 200,
      header = "Name"
    ),
    list(
      width = 150,
      value = "price",
      header = "Price"
    ),
    list(
      width = 150,
      value = "quantity",
      header = "Qty"
    )
  ),
  width = 600
)

jstree(nodes, grid = grid)

