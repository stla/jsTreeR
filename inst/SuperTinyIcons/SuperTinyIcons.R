library(rvest)
library(xml2)
setwd("C:/SL/MyPackages/jsTreeR/inst/SuperTinyIcons")

# to get the json ####
html <- read_html("https://github.com/edent/SuperTinyIcons")
tables <- html %>% html_elements("table")
# tables[2] %>% html_table()

ncells <- vapply(2:length(tables), function(i) {
  sum(xml_length(tables[i] %>% html_element("tbody") %>% html_elements("tr")))
}, integer(1L))
total <- sum(ncells)

first <- 8
links <-
  na.omit(html %>% html_elements("img") %>% html_attr("data-canonical-src"))
svgs <- basename(links[first:(first+total-1)])
svgs[duplicated(svgs)]

categories <-
  html %>% xml_find_all('//h3[@dir="auto"]') %>% xml_text()
categories <- categories[1:18]

chunks <- vector("list", length(ncells))
chunks[[1]] <- seq_len(ncells[1])
for(i in 2:length(ncells)){
  chunks[[i]] <- seq_len(ncells[i]) + sum(ncells[1:(i-1)])
}

x <- lapply(chunks, function(chunk) svgs[chunk])
names(x) <- categories

.simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1, 1)), substring(s, 2),
        sep = "", collapse = " ")
}
makechildren <- function(svg){
  z <- tools::file_path_sans_ext(svg)
  list(
    text = .simpleCap(z),
    icon = paste0("supertinyicon-", z),
    data = list(
      svg = svg
    )
  )
}

rjson <- lapply(categories, function(ctg){
  list(
    text = ctg,
    children = lapply(x[[ctg]], makechildren)
  )
})
cat(jsonlite::toJSON(rjson, auto_unbox = TRUE, pretty = TRUE),
    file = "SuperTinyIcons.json")

# make the css ####
svgs <- sort(svgs)
svgs <- c(svgs, paste0("transparent-", svgs))

css <- vapply(tools::file_path_sans_ext(svgs), function(f){
  sprintf(".supertinyicon-%s::before {
  content: url(./%s.svg);
}", f, f)
}, character(1L))
cat(css, file = "SuperTinyIcons.css", sep = "\n")

# make the transparent icons ####
tinyIcon <- function(svg){
  XML <- read_xml(svg)
  xml_set_attr(xml_child(XML), "fill", "transparent")
  write_xml(XML, paste0("transparent-", svg))
}
setwd("C:/SL/MyPackages/jsTreeR/inst/SuperTinyIcons/SuperTinyIcons/images/svg")
svgs <- list.files(".", pattern = "svg$")
lapply(svgs, tinyIcon)





















