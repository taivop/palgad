library(dplyr)
library(rvest)
library(readxl)
library(jsonlite)
library(rjson)

palgad_riik <- read_excel("data/palgad_riik.xlsx",
                          col_types=c(rep("text", 6), "numeric", "numeric"))

make_node = function(root_name, children) {
  root <- list()
  root$name <- root_name
  root$children <- children
  
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

step_size <- 20

root <- make_node("Riigiasutused", list())
root$children <- c(root$children, to_list(asutused[1:step_size,]))

for(i in seq(step_size+1, nrow(asutused), step_size)) {
  i_end <- min(i+step_size, nrow(asutused))
  root$children <- c(root$children, list(make_node(
    sprintf("Grupp %d-%d", i, i_end),
    to_list(asutused[i:i_end,]))))
}

cat(toJSON(root), file="../data/flare_kov.json")

