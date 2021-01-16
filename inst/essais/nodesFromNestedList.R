L <- list(
  Europe = list(
    "France", "Germany"
  ),
  America = list(
    NorthAmerica = list(
      "Canada", "USA"
    ),
    SouthAmerica = list(
      "Mexic", "Brazil"
    )
  )
)

f <- function(L){
  if(length(names(L))){
    lapply(names(L), function(nm){
      list(text = nm, children = f(L[[nm]]))
    })
  }else{
    lapply(L, function(x) list(text = x))
  }
}

f(L)
