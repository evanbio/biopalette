<div align="center">

<img src="man/figures/logo.png" width="180" alt="biopalette logo" />

# biopalette

### *Image-Inspired Color Palettes for Biomedical Visualization*

[![R-CMD-check](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml)
[![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

[📚 Documentation](https://evanbio.github.io/biopalette/) •
[💬 Issues](https://github.com/evanbio/biopalette/issues)

---

**Languages:** English | [简体中文](README_zh.md)

</div>

---

## Overview

**biopalette** is an R package providing story-driven color palettes for biomedical visualization.

Every palette begins with a real image — a film still, a scientific figure, an artwork — and is translated into a reproducible color system. The source is always documented: where the colors came from, what they mean, and when to use them.

```r
library(biopalette)

get_palette("babel", n = 5)
get_palette("three_body")
get_palette("walter_white", type = "diverging")

preview_palette("gene_red")
palette_gallery()
```

---

## Installation

```r
# Development version
devtools::install_github("evanbio/biopalette")
```

**Requires:** R ≥ 4.1.0

---

## Palettes

| Name | Type | Colors | Source |
|---|---|---|---|
| `gene_red` | Qualitative | 2 | *Better Call Saul* — Gene Takavic's red coat |
| `walter_white` | Diverging | 5 | *Breaking Bad* — desert to sky |
| `walter_white2` | Qualitative | 5 | *Breaking Bad* — muted earth tones |
| `walter_white3` | Diverging | 5 | *Breaking Bad* — warm counterpart |
| `babel` | Qualitative | 21 | Pan-cancer myeloid atlas (Cell, 2021) — 22 cell types, 21 voices |
| `three_body` | Qualitative | 3 | Pan-cancer myeloid atlas (Cell, 2021) — three DC trajectories |

---

## Function Reference

<details>
<summary><b>🎨 Palette Access</b> (3)</summary>

- `get_palette()` — retrieve colors by name, type, and size
- `list_palettes()` — data frame of all available palettes
- `palette_gallery()` — paged visual gallery of all palettes

</details>

<details>
<summary><b>🔧 Palette Management</b> (4)</summary>

- `create_palette()` — write a new palette to JSON
- `compile_palettes()` — compile all JSONs into a named list
- `remove_palette()` — remove a palette by name
- `preview_palette()` — render color swatches to a plot

</details>

<details>
<summary><b>🔵 Color Utilities</b> (2)</summary>

- `hex2rgb()` — convert HEX to RGB
- `rgb2hex()` — convert RGB to HEX

</details>

---

## License

MIT License © 2025–2026 [Yibin Zhou](mailto:evanzhou.bio@gmail.com)

<div align="center">

**Made with ❤️ by [Yibin Zhou](https://github.com/evanbio)**

</div>
