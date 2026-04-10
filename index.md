# biopalette

> Image-Inspired Color Palettes for Biomedical Visualization

[![R-CMD-check](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml)
[![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

---

## Overview

**biopalette** is an R package providing story-driven color palettes for biomedical visualization.

Every palette begins with a real image — a film still, a scientific figure, an artwork — and is translated into a reproducible color system. The source is always documented: where the colors came from, what they mean, and when to use them.

## Installation

```r
devtools::install_github("evanbio/biopalette")
```

## Quick Start

```r
library(biopalette)

get_palette("babel", n = 5)
get_palette("three_body")
get_palette("walter_white", type = "diverging")

preview_palette("gene_red")
palette_gallery()
```

## Palettes

| Name | Type | Colors | Source |
|---|---|---|---|
| `gene_red` | Qualitative | 2 | *Better Call Saul* — Gene Takavic's red coat |
| `walter_white` | Diverging | 5 | *Breaking Bad* — desert to sky |
| `walter_white2` | Qualitative | 5 | *Breaking Bad* — muted earth tones |
| `walter_white3` | Diverging | 5 | *Breaking Bad* — warm counterpart |
| `babel` | Qualitative | 21 | Pan-cancer myeloid atlas (Cell, 2021) |
| `three_body` | Qualitative | 3 | Pan-cancer myeloid atlas (Cell, 2021) |

## Function Areas

| Area | Functions |
|---|---|
| Palette access | `get_palette()`, `list_palettes()`, `palette_gallery()` |
| Palette management | `create_palette()`, `compile_palettes()`, `remove_palette()`, `preview_palette()` |
| Color utilities | `hex2rgb()`, `rgb2hex()` |

## Documentation

- [Function Reference](reference/index.html)

## License

MIT License © 2025–2026 Yibin Zhou
