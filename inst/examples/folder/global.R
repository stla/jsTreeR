library(jsTreeR)
library(shiny)
library(jsonlite)

# make the nodes list from a vector of file paths
makeNodes <- function(leaves){
  dfs <- lapply(strsplit(leaves, "/"), function(s){
    item <-
      Reduce(function(a,b) paste0(a,"/",b), s[-1], s[1], accumulate = TRUE)
    data.frame(
      item = item,
      parent = c("root", item[-length(item)]),
      stringsAsFactors = FALSE
    )
  })
  dat <- dfs[[1]]
  for(i in 2:length(dfs)){
    dat <- merge(dat, dfs[[i]], all = TRUE)
  }
  f <- function(parent){
    i <- match(parent, dat$item)
    item <- dat$item[i]
    children <- dat$item[dat$parent==item]
    label <- tail(strsplit(item, "/")[[1]], 1)
    if(length(children)){
      list(
        text = label,
        data = list(value = item),
        children = lapply(children, f)
      )
    }else{
      list(text = label, data = list(value = item))
    }
  }
  lapply(dat$item[dat$parent == "root"], f)
}

folder <-
  list.files(system.file("www", "shared", package = "shiny"), recursive = TRUE)
nodes <- makeNodes(folder)
