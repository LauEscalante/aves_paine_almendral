# aves_paine_almendral

Proyecto final del curso *Visualización de datos medioambientales con R*.

Análisis de la comunidad de aves de un predio agrícola de paltos y almendros en Paine (Región Metropolitana, Chile), a partir de un conjunto de datos públicos. Aún no tengo datos de tesis, así que uso este dataset externo como la aproximación más cercana a un trabajo real de monitoreo.

**Los datos son reales y no fueron generados por mí ni por IA.** Pertenecen a sus autores y se usan con fines académicos.

## Fuente de los datos

Alvarado Orellana S A, Santander Zapata F J, Figueroa Rojas R A, Flores Meza S P (2021). *Monitoreo de aves rapaces y no rapaces en una plantación de paltos y almendros, comuna de Paine, Región Metropolitana de Santiago, Chile.* Versión 1.3. Ministerio del Medio Ambiente de Chile. https://doi.org/10.15468/33myh9 (GBIF, licencia CC BY 4.0). Consultoría "Fomento del servicio ecosistémico de control de plagas por parte de aves rapaces en el predio El Almendral", Proyecto GEF Montaña, realizada por la Unión de Ornitólogos de Chile (UNORCH).

- 407 registros (ocurrencias) de 38 especies (9 rapaces y 29 no rapaces), provenientes de 122 eventos de monitoreo entre diciembre 2019 y septiembre 2020 (8 monitoreos mensuales, M1 a M8).
- Predio agrícola de paltos y almendros (~220 ha) en zona pre-montañosa colindante a bosque esclerófilo, comuna de Paine.
- Tres metodologías en distintos puntos de muestreo: U (censos de aves no rapaces diurnas dentro de la plantación), E (censos de rapaces diurnas en el borde plantación-bosque) y N (censos de rapaces nocturnas con playback).
- El esfuerzo de muestreo cambió durante el estudio (radio, tiempo y número de puntos), por lo que los monitoreos se comparan dentro de un mismo método.
- Este repositorio usa solo el archivo de ocurrencias (407 registros). El archivo completo del IPT incluye además la tabla de eventos (122, con los monitoreos sin aves), pendiente de incorporar.

## Estructura

* `datos/raw/`: archivo original de GBIF, sin modificar
* `datos/processed/`: tablas generadas a partir del proceso de limpieza
* `scripts/`: scripts de R numerados en orden de ejecución
* `resultados/`: tablas de resultados generadas por los scripts
* `figuras/`: gráficos generados en el análisis
* `informe/`: actividades del curso e informe final

## Scripts

1. `01_limpieza.R`: lectura, chequeos y limpieza de los datos crudos
2. `02_eda.R`: análisis exploratorio (especies más abundantes, riqueza por monitoreo)
3. `03_datos_ausentes.R`: resumen y visualización de datos ausentes

## Estado del proyecto

En desarrollo como parte de las actividades del curso.
