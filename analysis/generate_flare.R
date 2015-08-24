library(dplyr)
library(rvest)
library(readxl)
library(jsonlite)
library(rjson)

palgad_riik <- read_excel("data/palgad_riik.xlsx",
                          col_types=c(rep("text", 6), "numeric", "numeric"))

make_node = function(root_name, children, add_size) {
  root <- list()
  root$name <- root_name
  root$children <- children
  
  if(!missing(add_size) && add_size)
    root$size <- 1000
  
  return(root)
}

to_list = function(asutused, root_name) {
  l <- list() # will start filling this
  
  for(i in 1:nrow(asutused)) {
    asutus <- asutused[i,]
    
    asutus_obj <- list()
    asutus_obj$size <- asutus$palgasumma
    asutus_obj$name <- asutus$Asutus
    
    l <- c(l, list(asutus_obj))
  }
  
  return(l)
}

asutused <- palgad_riik %>%
  group_by(Asutus) %>%
  summarise(inimesi=n(), palgasumma=sum(Põhipalk)) %>%
  arrange(desc(palgasumma))

root <- make_node("Riigiasutused", list())
root$children <- c(root$children, to_list(asutused[1:3,]))
root$children <- c(root$children, list(make_node("alam", to_list(asutused[4:6,]), TRUE)))

cat(toJSON(root), file="../data/flare2.json")
