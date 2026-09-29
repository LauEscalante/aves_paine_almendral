# ==============================================================================
# Script: 01_limpieza.R
# Proyecto: Aves en una plantacion de paltos y almendros (Paine, Chile)
# Objetivo: pasar del archivo crudo GBIF a una tabla limpia y ordenada
# Fuente: Alvarado et al. (2021), MMA Chile, GBIF, doi:10.15468/33myh9
# ==============================================================================

library(tidyverse)
library(here)

# 1. Importar datos crudos --------------------------------
aves_crudo <- read_tsv(here("datos", "raw", "aves_paine_ocurrencias_raw.tsv"))

# 2. Chequeos: los datos contienen lo que deberian contener --------------------
stopifnot(
  nrow(aves_crudo) == 407,
  n_distinct(aves_crudo$species) == 38,
  all(aves_crudo$individualCount >= 1),
  all(aves_crudo$establishmentMeans %in% c("native", "introduced")),
  inherits(aves_crudo$eventDate, "Date")
)

# 3. Seleccionar columnas utiles y separar el occurrenceID ---------------------
# Ejemplo de ID: MMA:GEFMONT:ALM:U5:M5_4
#   punto = U5 (la letra es el metodo: U, E o N), monitoreo = M5, registro = 4
aves <- aves_crudo |>
  select(gbifID, occurrenceID, order, family, species,
         individualCount, establishmentMeans, eventDate) |>
  separate(occurrenceID,
           into = c("org", "proyecto", "predio", "punto", "monitoreo_registro"),
           sep = ":") |>
  separate(monitoreo_registro,
           into = c("monitoreo", "n_registro"),
           sep = "_") |>
  select(-org, -proyecto, -predio) |>
  mutate(
    metodo = str_sub(punto, 1, 1),   # U = plantacion, E = borde, N = nocturno
    origen = if_else(establishmentMeans == "native", "nativa", "introducida")
  )

# 4. Chequeo del resultado -----------------------------------------------------
stopifnot(all(aves$metodo %in% c("U", "E", "N")))
glimpse(aves)

# 5. Guardar tabla limpia ------------------------------------------------------
dir.create(here("datos", "processed"), showWarnings = FALSE, recursive = TRUE)
write_csv(aves, here("datos", "processed", "aves_paine_ocurrencias_limpio.csv"))
