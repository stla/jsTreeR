library(jsTreeR)
library(shiny)

nodes <- list(
  list(
    text = "Fruits",
    type = "fruit",
    icon = "supertinyicon-transparent-raspberry_pi",
    a_attr = list(class = "helvetica"),
    children = list(
      list(
        text = "Apple",
        type = "fruit",
        data = list(
          price = 0.1,
          quantity = 20,
          cssclass = "lightorange"
        )
      ),
      list(
        text = "Banana",
        type = "fruit",
        data = list(
          price = 0.2,
          quantity = 31,
          cssclass = "lightorange"
        )
      ),
      list(
        text = "Grapes",
        type = "fruit",
        data = list(
          price = 1.99,
          quantity = 34,
          cssclass = "lightorange"
        )
      ),
      list(
        text = "Mango",
        type = "fruit",
        data = list(
          price = 0.5,
          quantity = 8,
          cssclass = "lightorange"
        )
      ),
      list(
        text = "Melon",
        type = "fruit",
        data = list(
          price = 0.8,
          quantity = 4,
          cssclass = "lightorange"
        )
      ),
      list(
        text = "Pear",
        type = "fruit",
        data = list(
          price = 0.1,
          quantity = 30,
          cssclass = "lightorange"
        )
      ),
      list(
        text = "Strawberry",
        type = "fruit",
        data = list(
          price = 0.15,
          quantity = 32,
          cssclass = "lightorange"
        )
      )
    ),
    state = list(
      opened = TRUE
    )
  ),
  list(
    text = "Vegetables",
    type = "vegetable",
    icon = "supertinyicon-transparent-vegetarian",
    a_attr = list(class = "helvetica"),
    children = list(
      list(
        text = "Aubergine",
        type = "vegetable",
        data = list(
          price = 0.5,
          quantity = 8,
          cssclass = "lightgreen"
        )
      ),
      list(
        text = "Broccoli",
        type = "vegetable",
        data = list(
          price = 0.4,
          quantity = 22,
          cssclass = "lightgreen"
        )
      ),
      list(
        text = "Carrot",
        type = "vegetable",
        data = list(
          price = 0.1,
          quantity = 32,
          cssclass = "lightgreen"
        )
      ),
      list(
        text = "Cauliflower",
        type = "vegetable",
        data = list(
          price = 0.45,
          quantity = 18,
          cssclass = "lightgreen"
        )
      ),
      list(
        text = "Potato",
        type = "vegetable",
        data = list(
          price = 0.2,
          quantity = 38,
          cssclass = "lightgreen"
        )
      )
    )
  )
)

grid <- list(
  columns = list(
    list(
      width = 200,
      header = "Product",
      headerClass = "bolditalic yellow centered",
      wideValueClass = "cssclass"
    ),
    list(
      width = 150,
      value = "price",
      header = "Price",
      wideValueClass = "cssclass",
      headerClass = "bolditalic yellow centered",
      wideCellClass = "centered"
    ),
    list(
      width = 150,
      value = "quantity",
      header = "Quantity",
      wideValueClass = "cssclass",
      headerClass = "bolditalic yellow centered",
      wideCellClass = "centered"
    )
  ),
  width = 600
)

types <- list(
  fruit = list(
    a_attr = list(
      class = "lightorange"
    ),
    icon = "supertinyicon-transparent-symantec"
  ),
  vegetable = list(
    a_attr = list(
      class = "lightgreen"
    ),
    icon = "supertinyicon-transparent-symantec"
  )
)
