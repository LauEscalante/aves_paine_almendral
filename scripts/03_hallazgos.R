# Cargar librerias ----------------------------------------------------------
paquetes <- c("tidyverse", "here")
faltan <- paquetes[!vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)]
if (length(faltan) > 0) stop("Faltan paquetes: ", paste(faltan, collapse = ", "),
                             ". Instalalos con install.packages().")

library(tidyverse)
library(here)

# Paleta Okabe-Ito (apta para daltonismo) -------------------------------------
oi <- c(
  naranjo   = "#E69F00",
  celeste   = "#56B4E9",
  verde     = "#009E73",
  amarillo  = "#F0E442",
  azul      = "#0072B2",
  bermellon = "#D55E00",
  rosado    = "#CC79A7",
  negro     = "#000000"
)

# Tema comun para todas las figuras ------------------------------------------
tema_proyecto <- function(base_size = 14) {
  theme_bw(base_size = base_size, base_family = "serif") +
    theme(
      plot.title = element_text(face = "bold", size = base_size + 3, hjust = 0.5),
      axis.title = element_text(face = "bold"),
      axis.text = element_text(color = "black"),
      legend.title = element_text(face = "bold"),
      panel.grid.minor = element_blank()
    )
}

# Cargar datos procesados ----------------------------------------------------
aves <- read_csv(here("datos", "processed", "aves_paine_ocurrencias_limpio.csv"))

dir.create(here("figuras"), showWarnings = FALSE)
dir.create(here("resultados"), showWarnings = FALSE)

# Fecha de cada monitoreo (segun eventDate) ----------------------------------
meses <- c("ene", "feb", "mar", "abr", "may", "jun",
           "jul", "ago", "sep", "oct", "nov", "dic")

fechas <- aves %>%
  mutate(fecha = as.Date(eventDate)) %>%
  group_by(monitoreo) %>%
  summarise(fecha = min(fecha), .groups = "drop") %>%
  mutate(mes_anio = paste(meses[month(fecha)], year(fecha)))

stopifnot(nrow(fechas) == 8)

ordenes_rapaces <- c("Accipitriformes", "Falconiformes", "Strigiformes")

# Hallazgo 1: quien domina la plantacion -------------------------------------
top_especies <- aves %>%
  group_by(species, origen) %>%
  summarise(individuos = sum(individualCount), .groups = "drop") %>%
  slice_max(individuos, n = 10)

fig_dominancia <- ggplot(top_especies,
                         aes(x = individuos,
                             y = fct_reorder(species, individuos),
                             fill = origen)) +
  geom_col() +
  scale_fill_manual(values = c(nativa = oi[["azul"]],
                               introducida = oi[["bermellon"]])) +
  labs(
    title = "Las diez especies de aves más abundantes",
    x = "Individuos registrados", y = NULL, fill = "Origen"
  ) +
  tema_proyecto()

print(fig_dominancia)
ggsave(here("figuras", "01_dominancia.png"),
       fig_dominancia, width = 9, height = 5, dpi = 300)

# Hallazgo 1b: porcentaje de individuos introducidos por monitoreo (método U) --
intro_u <- aves %>%
  filter(metodo == "U") %>%
  group_by(monitoreo) %>%
  summarise(
    individuos = sum(individualCount),
    pct_introducidas = 100 * sum(individualCount[origen == "introducida"]) /
      sum(individualCount),
    .groups = "drop"
  ) %>%
  left_join(fechas, by = "monitoreo") %>%
  arrange(fecha) %>%
  mutate(etiqueta = fct_inorder(
    paste0(monitoreo, "\n", mes_anio, "\n(n = ", individuos, ")")
  ))

fig_introducidas <- ggplot(intro_u, aes(x = etiqueta, y = pct_introducidas, group = 1)) +
  geom_line(colour = oi[["bermellon"]]) +
  geom_point(colour = oi[["bermellon"]], size = 3) +
  geom_text(aes(label = paste0(round(pct_introducidas, 0), " %")),
            vjust = -1, size = 3.2) +
  scale_y_continuous(limits = c(0, 55)) +
  labs(
    title = "Aves introducidas por monitoreo (método U)",
    x = "Monitoreo, fecha y número de individuos (n)",
    y = "Individuos introducidos (%)"
  ) +
  tema_proyecto()

print(fig_introducidas)
ggsave(here("figuras", "02_introducidas_por_monitoreo.png"),
       fig_introducidas, width = 9, height = 5, dpi = 300)

write_csv(intro_u, here("resultados", "introducidas_por_monitoreo_metodo_u.csv"))

# Hallazgo 2: que rapaces aparecen y cuando ----------------------------------
rapaces <- aves %>%
  filter(order %in% ordenes_rapaces) %>%
  group_by(species, monitoreo) %>%
  summarise(individuos = sum(individualCount), .groups = "drop") %>%
  complete(species, monitoreo = fechas$monitoreo,
           fill = list(individuos = 0)) %>%
  left_join(fechas, by = "monitoreo") %>%
  mutate(
    species = fct_reorder(species, individuos, .fun = sum),
    etiqueta = fct_reorder(paste0(monitoreo, "\n", mes_anio), fecha)
  )

fig_rapaces <- ggplot(rapaces, aes(x = etiqueta, y = species, fill = individuos)) +
  geom_tile(colour = "white") +
  geom_text(aes(label = if_else(individuos > 0, as.character(individuos), ""),
                colour = individuos > 15),
            size = 3) +
  scale_colour_manual(values = c("FALSE" = "black", "TRUE" = "white"), guide = "none") +
  scale_fill_gradient(low = "white", high = oi[["azul"]], name = "Individuos") +
  labs(
    title = "Rapaces registradas por monitoreo",
    x = "Monitoreo y fecha", y = "Especie"
  ) +
  tema_proyecto() +
  theme(panel.grid = element_blank())

print(fig_rapaces)
ggsave(here("figuras", "03_rapaces_por_monitoreo.png"),
       fig_rapaces, width = 9, height = 5, dpi = 300)

write_csv(rapaces, here("resultados", "rapaces_por_monitoreo.csv"))

# Versiones usadas ------------------------------------------------------------
writeLines(capture.output(sessionInfo()), here("resultados", "session_info.txt"))
