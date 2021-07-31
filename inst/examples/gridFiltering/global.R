library(jsTreeR)
library(shiny)
library(htmlwidgets)
library(magrittr)

data("Countries")
rownames(Countries) <- Countries[["countryName"]]
dat <- split(Countries, Countries[["continentName"]])
nodes <- lapply(names(dat), function(continent){
  list(
    text = continent,
    children = lapply(dat[[continent]][["countryName"]], function(cntry){
      list(
        text = cntry,
        data = list(
          countrycode = Countries[cntry, "countryCode"],
          capital = Countries[cntry, "capital"],
          population = Countries[cntry, "population"]
        )
      )
    })
  )
})
grid <- list(
  columns = list(
    list(
      width = 430,
      header = "Country",
      headerClass = "yellow"
    ),
    list(
      width = 150,
      value = "capital",
      header = "Capital",
      wideCellClass = "lightorange",
      headerClass = "yellow"
    ),
    list(
      width = 110,
      value = "countrycode",
      header = "Country code",
      wideCellClass = "centered lightgreen",
      headerClass = "yellow"
    ),
    list(
      width = 150,
      value = "population",
      header = "Population",
      wideCellClass = "lightorange",
      headerClass = "yellow"
    )
  ),
  width = 850
)
onrender <- c(
  "function(el, x) {",
  "  Shiny.addCustomMessageHandler('hideNodes', function(range) {",
  "    var tree = $.jstree.reference(el.id);",
  "    var json = tree.get_json(null, {flat: true});",
  "    for(var i = 0; i < json.length; i++) {",
  "      var id = json[i].id;",
  "      if(tree.is_leaf(id)) {",
  "        var pop = json[i].data.population;",
  "        if(pop < range[0] || pop > range[1]) {",
  "          tree.hide_node(id);",
  "        } else {",
  "          tree.show_node(id);",
  "        }",
  "      }",
  "    }",
  "  });",
  "}"
)
