# Changelog

## biopalette 0.1.0

*Released: April 2026*

Initial release of **biopalette** — image-inspired color palettes for
biomedical visualization.

### New Features

- [`get_palette()`](https://evanbio.github.io/biopalette/reference/get_palette.md)
  — retrieve colors by name, type, and size
- [`palette_info()`](https://evanbio.github.io/biopalette/reference/palette_info.md)
  — metadata for one named palette
- [`list_palettes()`](https://evanbio.github.io/biopalette/reference/list_palettes.md)
  — data frame of all available palettes
- [`palette_gallery()`](https://evanbio.github.io/biopalette/reference/palette_gallery.md)
  — paged visual gallery of all palettes
- [`preview_palette()`](https://evanbio.github.io/biopalette/reference/preview_palette.md)
  — render color swatches to a plot
- [`create_palette()`](https://evanbio.github.io/biopalette/reference/create_palette.md)
  — write a new palette to JSON
- [`remove_palette()`](https://evanbio.github.io/biopalette/reference/remove_palette.md)
  — remove a palette by name
- [`hex2rgb()`](https://evanbio.github.io/biopalette/reference/hex2rgb.md)
  — convert HEX to RGB
- [`rgb2hex()`](https://evanbio.github.io/biopalette/reference/rgb2hex.md)
  — convert RGB to HEX
- [`scale_color_biopalette()`](https://evanbio.github.io/biopalette/reference/scale_color_biopalette.md)
  /
  [`scale_fill_biopalette()`](https://evanbio.github.io/biopalette/reference/scale_color_biopalette.md)
  — discrete ggplot2 scales
- [`scale_color_biopalette_gradient()`](https://evanbio.github.io/biopalette/reference/scale_color_biopalette_gradient.md)
  /
  [`scale_fill_biopalette_gradient()`](https://evanbio.github.io/biopalette/reference/scale_color_biopalette_gradient.md)
  — continuous ggplot2 gradients

### Palettes

- `gene_red` — qualitative, 2 colors. *Better Call Saul* — Gene
  Takavic’s red coat
- `walter_white` — diverging, 5 colors. *Breaking Bad* — desert to sky
- `walter_white2` — qualitative, 5 colors. *Breaking Bad* — muted earth
  tones
- `walter_white3` — diverging, 5 colors. *Breaking Bad* — warm
  counterpart
- `babel` — qualitative, 21 colors. Pan-cancer myeloid atlas (Cell,
  2021)
- `three_body` — qualitative, 3 colors. Pan-cancer myeloid atlas (Cell,
  2021)
- `heat_light` — qualitative, 2 colors. Bond ampholysis (Nature, 2024)
- `tam_pastel` — qualitative, 6 colors. Pan-cancer myeloid atlas (Cell,
  2021)
- `cancer_mosaic` — qualitative, 15 colors. Pan-cancer myeloid atlas
  (Cell, 2021)
- `lactate_steps` — qualitative, 5 colors. Lactate metabolism and
  immunotherapy (JECCR, 2024)
- `mitonuclear_blue` — sequential, 6 colors. Mito-nuclear communication
  in aging (TIBS, 2022)
- `mitonuclear_orange` — sequential, 6 colors. Mito-nuclear
  communication in aging (TIBS, 2022)
