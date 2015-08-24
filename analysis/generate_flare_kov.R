library(dplyr)
library(rvest)
library(readxl)
library(jsonlite)
library(rjson)

palgad <- read_excel("data/palgad_kov.xlsx",
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
    asutus_obj$size <- round(asutus$palgasumma)
    asutus_obj$name <- asutus$Asutus
    
    l <- c(l, list(asutus_obj))
  }
  
  return(l)
}

asutused <- palgad %>%
  group_by(Asutus) %>%
  summarise(inimesi=n(), palgasumma=sum(Põhipalk)) %>%
  arrange(desc(palgasumma)) %>%
  mutate(Asutus=gsub("Linnavalitsus", "linn", Asutus)) %>%
  mutate(Asutus=gsub("Vallavalitsus", "vald", Asutus))

step_size <- 20

root <- make_node("Riigiasutused", list())
root$children <- c(root$children, to_list(asutused))


cat(toJSON(root), file="../data/flare_kov.json")

