# Changelog

## biopalette 0.1.0

*Released: April 2026*

Initial release of **biopalette** — image-inspired color palettes for
biomedical visualization.

### New Features

- [`get_palette()`](https://evanbio.github.io/biopalette/reference/get_palette.md)
  — retrieve colors by name, type, and size
- [`list_palettes()`](https://evanbio.github.io/biopalette/reference/list_palettes.md)
  — data frame of all available palettes
- [`palette_gallery()`](https://evanbio.github.io/biopalette/reference/palette_gallery.md)
  — paged visual gallery of all palettes
- [`preview_palette()`](https://evanbio.github.io/biopalette/reference/preview_palette.md)
  — render color swatches to a plot
- [`create_palette()`](https://evanbio.github.io/biopalette/reference/create_palette.md)
  — write a new palette to JSON
- [`compile_palettes()`](https://evanbio.github.io/biopalette/reference/compile_palettes.md)
  — compile all JSONs into a named list
- [`remove_palette()`](https://evanbio.github.io/biopalette/reference/remove_palette.md)
  — remove a palette by name
- [`hex2rgb()`](https://evanbio.github.io/biopalette/reference/hex2rgb.md)
  — convert HEX to RGB
- [`rgb2hex()`](https://evanbio.github.io/biopalette/reference/rgb2hex.md)
  — convert RGB to HEX

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
