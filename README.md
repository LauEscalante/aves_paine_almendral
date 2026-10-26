# aves_paine_almendral

Proyecto final del curso *Visualización de datos medioambientales con R*.

Análisis de la comunidad de aves de un predio agrícola de paltos y almendros en Paine (Región Metropolitana, Chile), a partir de un conjunto de datos públicos.

**Los datos son reales y no fueron generados por mí ni por IA.** Pertenecen a sus autores y se usan con fines académicos.

## Fuente de los datos

Alvarado Orellana S A, Santander Zapata F J, Figueroa Rojas R A, Flores Meza S P (2021). *Monitoreo de aves rapaces y no rapaces en una plantación de paltos y almendros, comuna de Paine, Región Metropolitana de Santiago, Chile.* Versión 1.3. Ministerio del Medio Ambiente de Chile. https://doi.org/10.15468/33myh9 (GBIF, licencia CC BY 4.0). Consultoría "Fomento del servicio ecosistémico de control de plagas por parte de aves rapaces en el predio El Almendral", Proyecto GEF Montaña, realizada por la Unión de Ornitólogos de Chile (UNORCH).

- 407 registros (ocurrencias) de 38 especies (9 rapaces y 29 no rapaces), provenientes de 122 eventos de monitoreo entre diciembre 2019 y octubre 2020 (8 monitoreos, M1 a M8, según `eventDate`; no son mensuales: entre M6, junio, y M7, fines de agosto, hay un hueco).
- Predio agrícola de paltos y almendros (~220 ha) en zona pre-montañosa colindante a bosque esclerófilo, comuna de Paine.
- Tres metodologías en distintos puntos de muestreo: U (censos de aves no rapaces diurnas dentro de la plantación), E (censos de rapaces diurnas en el borde plantación-bosque) y N (censos de rapaces nocturnas con playback).
- El esfuerzo de muestreo cambió durante el estudio (radio, tiempo y número de puntos), por lo que los monitoreos se comparan dentro de un mismo método.
- Este repositorio usa solo el archivo de ocurrencias (407 registros). El archivo completo del IPT incluye además la tabla de eventos (122, con los monitoreos sin aves), pendiente de incorporar.

## Preguntas exploratorias

1. ¿Qué especies dominan el predio y cuáles son nativas o introducidas?
2. ¿Cómo cambia la proporción de aves introducidas entre monitoreos dentro de la plantación (método U)?
3. ¿Qué rapaces aparecen en cada monitoreo?

## Estructura

* `datos/raw/`: archivo original de GBIF, sin modificar
* `datos/processed/`: tablas generadas a partir del proceso de limpieza
* `scripts/`: scripts de R numerados en orden de ejecución
* `resultados/`: tablas de resultados generadas por los scripts
* `figuras/`: gráficos generados en el análisis
* `informe/`: borrador del informe final (Quarto)

## Scripts

1. `01_limpieza.R`: lectura, chequeos y limpieza de los datos crudos
2. `02_datos_ausentes.R`: resumen y visualización de datos ausentes
3. `03_hallazgos.R`: tres figuras de los hallazgos (dominancia, porcentaje de introducidas por monitoreo y rapaces por monitoreo), con paleta Okabe-Ito
4. `informe/informe_borrador.qmd`: borrador del informe (Quarto) que cuenta los tres hallazgos

## Cómo reproducir el análisis

1. Abrir `aves_paine_almendral.Rproj` en RStudio (así las rutas relativas con `here()` funcionan).
2. Instalar los paquetes: `install.packages(c("tidyverse", "here", "naniar", "knitr"))`. Quarto debe estar instalado para renderizar el informe.
3. Ejecutar en orden `scripts/01_limpieza.R`, `02_datos_ausentes.R` y `03_hallazgos.R`.
4. Renderizar `informe/informe_borrador.qmd` (genera el informe en HTML y en PDF).

El script 03 guarda las versiones de R y de los paquetes usadas en `resultados/session_info.txt`.

## Diccionario de variables (`datos/processed/aves_paine_ocurrencias_limpio.csv`)

| Variable | Descripción |
|---|---|
| `gbifID` | Identificador del registro en GBIF |
| `punto` | Punto de muestreo (la letra es el método: U, E o N) |
| `monitoreo` | Campaña de monitoreo, M1 a M8 |
| `n_registro` | Número del registro dentro del punto y monitoreo |
| `order`, `family`, `species` | Orden, familia y especie |
| `individualCount` | Número de individuos registrados |
| `establishmentMeans` | Origen según GBIF (`native` o `introduced`) |
| `eventDate` | Fecha del monitoreo |
| `metodo` | U = no rapaces en la plantación; E = rapaces diurnas en el borde; N = rapaces nocturnas con playback |
| `origen` | `nativa` o `introducida` (traducción de `establishmentMeans`) |

## Decisiones sobre los datos

- Las columnas totalmente vacías (coordenadas, elevación, etc.) son ausencias estructurales: los autores resguardaron las coordenadas (`informationWithheld`), no se perdieron. Por eso no hay mapas.
- El esfuerzo de muestreo cambió (puntos, radio, tiempo) y las rapaces nocturnas (N) solo tienen registros en M5, M7 y M8. Por eso los monitoreos se comparan dentro de un mismo método.
- Falta la tabla de eventos, así que un monitoreo sin registros de una especie no se puede distinguir de un monitoreo sin esfuerzo. Los ceros de las figuras de rapaces deben leerse con cuidado.
- No se eliminan filas por datos ausentes y el archivo crudo no se modifica.

## Uso de IA

Usé Claude (IA generativa) para entender la estructura, revisar y adaptar el código.

## Estado del proyecto

Primer borrador. Hay dos hallazgos con tres figuras y un informe en Quarto. Pendiente: incorporar la tabla de eventos, comparar la riqueza entre monitoreos (rarefacción) y mejorar el diseño de las figuras.
