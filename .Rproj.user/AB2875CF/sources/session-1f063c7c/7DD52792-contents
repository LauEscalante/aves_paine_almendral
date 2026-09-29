# Cargar librerias ----------------------------------------------------------
library(tidyverse)
library(here)

# Cargar datos procesados ----------------------------------------------------
aves <- read_csv(here("datos", "processed", "aves_paine_ocurrencias_limpio.csv"))

dir.create(here("figuras"), showWarnings = FALSE)

# Especies mas abundantes ----------------------------------------------------
top_especies <- aves %>%
  group_by(species, origen) %>%
  summarise(individuos = sum(individualCount), .groups = "drop") %>%
  slice_max(individuos, n = 10)

print(top_especies)

fig_top <- ggplot(top_especies,
                  aes(x = individuos, y = fct_reorder(species, individuos),
                      fill = origen)) +
  geom_col(alpha = 0.8) +
  labs(
    title = "Las 10 especies mas abundantes",
    x = "Individuos registrados", y = NULL, fill = "Origen"
  ) +
  theme_bw()

ggsave(here("figuras", "01_top_especies_abundancia.png"),
       fig_top, width = 8, height = 5, dpi = 300)

# Riqueza por monitoreo -------------------------------------------------------
riqueza <- aves %>%
  group_by(monitoreo) %>%
  summarise(
    especies = n_distinct(species),
    individuos = sum(individualCount),
    .groups = "drop"
  )

print(riqueza)

fig_riqueza <- ggplot(riqueza, aes(x = monitoreo, y = especies)) +
  geom_col(fill = "steelblue", alpha = 0.8) +
  labs(
    title = "Especies registradas por monitoreo",
    x = "Monitoreo (M1 = dic 2019, M8 = sep 2020)",
    y = "Numero de especies"
  ) +
  theme_bw()

ggsave(here("figuras", "02_riqueza_por_monitoreo.png"),
       fig_riqueza, width = 8, height = 5, dpi = 300)
print(fig_top)
print(fig_riqueza)
