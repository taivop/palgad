library(dplyr)
library(rvest)
library(readxl)


# Loe failid sisse
palgad_kov <- read_excel("data/palgad_kov.xlsx",
                  col_types=c(rep("text", 6), "numeric", "numeric")) %>%
  mutate(Tüüp="Kohalik omavalitsus")
palgad_riik <- read_excel("data/palgad_riik.xlsx",
                         col_types=c(rep("text", 6), "numeric", "numeric")) %>%
  mutate(Tüüp="Riigiasutus")

palgad <- rbind(palgad_kov, palgad_riik) %>%
  mutate(Täiskoormusega=Põhipalk/Koormus) %>%
  mutate(Nimi=ifelse(is.na(Eesnimi) | is.na(Perekonnanimi),
                     NA,
                     paste0(Eesnimi, " ", substr(Perekonnanimi, 0, 1)))) %>%
  mutate(Põhipalk=round(Põhipalk), Täiskoormusega=round(Täiskoormusega)) %>%
  mutate(Ametikoht=tolower(Ametikoht))
  select(Tüüp, Asutus, Struktuuriüksus, Nimi, Ametikoht, Koormus, Põhipalk,
         Täiskoormusega)


asutuse_kaupa <- palgad %>%
  group_by(Tüüp, Asutus) %>%
  summarise(Inimesi=n(), Koormust=sum(Koormus),
            Mediaan=median(Täiskoormusega),Keskmine=mean(Täiskoormusega),
            Miinimum=min(Täiskoormusega), Maksimum=max(Täiskoormusega)) %>%
  mutate_each(funs(round), Mediaan:Maksimum)

tookoha_kaupa <- palgad %>%
  group_by(Tüüp, Ametikoht) %>%
  summarise(Inimesi=n(), Koormust=sum(Koormus),
            Mediaan=median(Täiskoormusega),Keskmine=mean(Täiskoormusega),
            Miinimum=min(Täiskoormusega), Maksimum=max(Täiskoormusega)) %>%
  mutate_each(funs(round), Mediaan:Maksimum) %>%
  filter(Inimesi > 1)

write.csv(palgad, file="data/palgad.csv")
write.csv(asutuse_kaupa, file="data/asutuse_kaupa.csv")
write.csv(tookoha_kaupa, file="data/tookoha_kaupa.csv")