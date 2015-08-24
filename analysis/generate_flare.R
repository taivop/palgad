library(dplyr)
library(rvest)
library(readxl)
library(jsonlite)
library(rjson)

palgad_riik <- read_excel("data/palgad_riik.xlsx",
                          col_types=c(rep("text", 6), "numeric", "numeric"))

root <- list() # will start filling this
root$name <- "Riigiasutused"
root$children <- character()

asutused <- palgad_riik %>%
  group_by(Asutus) %>%
  summarise(count=n()) %>%
  top_n(20)

for(i in 1:nrow(asutused)) {
  asutus <- asutused[i,]

  asutus_obj <- list()
  asutus_obj$size <- asutus$count
  asutus_obj$name <- asutus$Asutus
  
  root$children <- c(root$children, list(asutus_obj))
}

cat(toJSON(root), file="../data/flare2.json")
