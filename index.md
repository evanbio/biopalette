# biopalette

> Image-Inspired Color Palettes for Biomedical Visualization

[![R-CMD-check](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml)
[![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

------------------------------------------------------------------------

## Overview

**biopalette** is an R package providing story-driven color palettes for
biomedical visualization.

Every palette begins with a real image — a film still, a scientific
figure, an artwork — and is translated into a reproducible color system.
The source is always documented: where the colors came from, what they
mean, and when to use them.

## Installation

``` r

devtools::install_github("evanbio/biopalette")
```

## Quick Start

``` r

library(biopalette)

get_palette("babel", n = 5)
get_palette("three_body")
get_palette("walter_white", type = "diverging")

preview_palette("gene_red")
palette_gallery()

scale_color_biopalette("three_body")
scale_fill_biopalette_gradient("mitonuclear_blue")
```

## Palettes

| Name | Type | Colors | Source |
|----|----|----|----|
| `gene_red` | Qualitative | 2 | *Better Call Saul* — Gene Takavic’s red coat |
| `walter_white` | Diverging | 5 | *Breaking Bad* — desert to sky |
| `walter_white2` | Qualitative | 5 | *Breaking Bad* — muted earth tones |
| `walter_white3` | Diverging | 5 | *Breaking Bad* — warm counterpart |
| `babel` | Qualitative | 21 | Pan-cancer myeloid atlas (Cell, 2021) |
| `three_body` | Qualitative | 3 | Pan-cancer myeloid atlas (Cell, 2021) |
| `heat_light` | Qualitative | 2 | Bond ampholysis (Nature, 2024) |
| `tam_pastel` | Qualitative | 6 | Pan-cancer myeloid atlas (Cell, 2021) |
| `cancer_mosaic` | Qualitative | 15 | Pan-cancer myeloid atlas (Cell, 2021) |
| `lactate_steps` | Qualitative | 5 | Lactate metabolism and immunotherapy (JECCR, 2024) |
| `mitonuclear_blue` | Sequential | 6 | Mito-nuclear communication in aging (TIBS, 2022) — young blue |
| `mitonuclear_orange` | Sequential | 6 | Mito-nuclear communication in aging (TIBS, 2022) — aged orange |

## Function Areas

| Area | Functions |
|----|----|
| Palette access | [`get_palette()`](https://evanbio.github.io/biopalette/reference/get_palette.md), [`palette_info()`](https://evanbio.github.io/biopalette/reference/palette_info.md), [`list_palettes()`](https://evanbio.github.io/biopalette/reference/list_palettes.md), [`palette_gallery()`](https://evanbio.github.io/biopalette/reference/palette_gallery.md) |
| Palette management | [`create_palette()`](https://evanbio.github.io/biopalette/reference/create_palette.md), [`remove_palette()`](https://evanbio.github.io/biopalette/reference/remove_palette.md), [`preview_palette()`](https://evanbio.github.io/biopalette/reference/preview_palette.md) |
| ggplot2 scales | [`scale_color_biopalette()`](https://evanbio.github.io/biopalette/reference/scale_color_biopalette.md), [`scale_fill_biopalette()`](https://evanbio.github.io/biopalette/reference/scale_color_biopalette.md), and gradient variants |
| Color utilities | [`hex2rgb()`](https://evanbio.github.io/biopalette/reference/hex2rgb.md), [`rgb2hex()`](https://evanbio.github.io/biopalette/reference/rgb2hex.md) |

## Documentation

- [Function
  Reference](https://evanbio.github.io/biopalette/reference/index.md)

## License

MIT License © 2025–2026 Yibin Zhou
