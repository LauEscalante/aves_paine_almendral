# Cargar librerias ----------------------------------------------------------
library(tidyverse)
library(here)
library(naniar)

# Cargar datos crudos ---------------------------------------------------
aves_crudo <- read_tsv(here("datos", "raw", "aves_paine_ocurrencias_raw.tsv"))

# Funcion para contar NA en una columna, aplicada a cada columna con purrr --
contar_na <- function(columna) {
  sum(is.na(columna))
}

n_na_por_columna <- purrr::map_dbl(aves_crudo, contar_na)

resumen_na <- tibble(
  variable = names(n_na_por_columna),
  n_na = n_na_por_columna,
  pct_na = round(100 * n_na_por_columna / nrow(aves_crudo), 1)
) %>%
  filter(n_na > 0) %>%
  arrange(desc(n_na))

print(resumen_na, n = Inf)

# Visualizacion de datos ausentes (naniar) -------------------------------
vis_miss(aves_crudo)

# Guardar resumen -----------------------------------------------------------
dir.create(here("resultados"), showWarnings = FALSE)
write_csv(resumen_na, here("resultados", "aves_paine_resumen_na.csv"))
