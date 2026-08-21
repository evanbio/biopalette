# biopalette 0.1.0

*Released: April 2026*

Initial release of **biopalette** — image-inspired color palettes for biomedical visualization.

## New Features

- `get_palette()` — retrieve colors by name, type, and size
- `palette_info()` — metadata for one named palette
- `list_palettes()` — data frame of all available palettes
- `palette_gallery()` — paged visual gallery of all palettes
- `preview_palette()` — render color swatches to a plot
- `create_palette()` — write a new palette to JSON
- `remove_palette()` — remove a palette by name
- `hex2rgb()` — convert HEX to RGB
- `rgb2hex()` — convert RGB to HEX
- `scale_color_biopalette()` / `scale_fill_biopalette()` — discrete ggplot2 scales
- `scale_color_biopalette_gradient()` / `scale_fill_biopalette_gradient()` — continuous ggplot2 gradients

## Palettes

- `gene_red` — qualitative, 2 colors. *Better Call Saul* — Gene Takavic's red coat
- `walter_white` — diverging, 5 colors. *Breaking Bad* — desert to sky
- `walter_white2` — qualitative, 5 colors. *Breaking Bad* — muted earth tones
- `walter_white3` — diverging, 5 colors. *Breaking Bad* — warm counterpart
- `babel` — qualitative, 21 colors. Pan-cancer myeloid atlas (Cell, 2021)
- `three_body` — qualitative, 3 colors. Pan-cancer myeloid atlas (Cell, 2021)
- `heat_light` — qualitative, 2 colors. Bond ampholysis (Nature, 2024)
- `tam_pastel` — qualitative, 6 colors. Pan-cancer myeloid atlas (Cell, 2021)
- `cancer_mosaic` — qualitative, 15 colors. Pan-cancer myeloid atlas (Cell, 2021)
- `lactate_steps` — qualitative, 5 colors. Lactate metabolism and immunotherapy (JECCR, 2024)
- `mitonuclear_blue` — sequential, 6 colors. Mito-nuclear communication in aging (TIBS, 2022)
- `mitonuclear_orange` — sequential, 6 colors. Mito-nuclear communication in aging (TIBS, 2022)
