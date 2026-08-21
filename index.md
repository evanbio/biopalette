# biopalette

> Image-Inspired Color Palettes for Biomedical Visualization

[![R-CMD-check](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml)
[![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

---

## Overview

**biopalette** is an R package providing image-inspired color palettes for biomedical visualization.

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

scale_color_biopalette("three_body")
scale_fill_biopalette_gradient("mitonuclear_blue")
```

## Palettes

| Name | Type | Colors | Recommended use | Source |
|---|---|---:|---|---|
| `gene_red` | Qualitative | 2 | Emphasized signal versus a dark or neutral counterpart | *Better Call Saul* — Gene Takavic's red coat |
| `walter_white` | Diverging | 5 | Signed continuous values around a neutral center | *Breaking Bad* — desert to sky |
| `walter_white2` | Qualitative | 5 | Up to five unordered groups | *Breaking Bad* — muted earth tones |
| `walter_white3` | Diverging | 5 | Warm-register signed continuous values | *Breaking Bad* — warm counterpart |
| `babel` | Qualitative | 21 | Many categorical groups with labels or position support | Pan-cancer myeloid atlas (Cell, 2021) |
| `bcell_atlas` | Qualitative | 7 | Four-to-seven categorical groups with direct labels or position support | Pan-cancer B-cell atlas (Cell, 2024) — graphical abstract |
| `bcell_atlas2` | Diverging | 5 | Signed change between warm and cool biological states | Pan-cancer B-cell atlas (Cell, 2024) — IgA to IgG shift |
| `three_body` | Qualitative | 3 | Three groups, lineages, or trajectories | Pan-cancer myeloid atlas (Cell, 2021) |
| `heat_light` | Qualitative | 2 | Paired categories or experimental conditions | Bond ampholysis (Nature, 2024) |
| `tam_pastel` | Qualitative | 6 | Four-to-six categorical groups on light backgrounds | Pan-cancer myeloid atlas (Cell, 2021) |
| `cancer_mosaic` | Qualitative | 15 | Ten-to-fifteen categories with labels or position support | Pan-cancer myeloid atlas (Cell, 2021) |
| `lactate_steps` | Qualitative | 5 | Five discrete workflow stages or study groups | Lactate metabolism and immunotherapy (JECCR, 2024) |
| `mitonuclear_blue` | Sequential | 6 | Cool low-to-high continuous values | Mito-nuclear communication in aging (TIBS, 2022) — young blue |
| `mitonuclear_orange` | Sequential | 6 | Warm low-to-high continuous values | Mito-nuclear communication in aging (TIBS, 2022) — aged orange |

## Function Areas

| Area | Functions |
|---|---|
| Palette access | `get_palette()`, `palette_info()`, `list_palettes()`, `palette_gallery()` |
| Palette management | `create_palette()`, `remove_palette()`, `preview_palette()` |
| ggplot2 scales | `scale_color_biopalette()`, `scale_fill_biopalette()`, and gradient variants |
| Color utilities | `hex2rgb()`, `rgb2hex()` |

## Documentation

- [Function Reference](reference/index.html)

## From Palette to Figure

**biopalette** provides the R interface for retrieving and applying
image-inspired palettes. **[Tessera](https://folio.evanzhou.org/tessera)**
documents their source images, example data, and reproducible R figure
recipes. **[Palette Lab](https://folio.evanzhou.org/apps/palette-lab)** keeps
the data and graphical structure fixed while comparing palette behavior across
17 graphical contexts.

<p align="center">
  <img src="man/figures/showcase/showcase-lab-overview.webp"
       alt="Palette Lab overview showing representative graphical contexts"
       width="100%" />
</p>

The panels below are rendered from Palette Lab with fixed data and figure
structure. Each Tessera link provides the corresponding reproducible figure
recipe and data context.

<table>
<tr>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/grouped_scatter"><img src="man/figures/showcase/showcase-scatter.webp" alt="Grouped scatter plot using babel" width="100%" /></a><br />
  <sub><b>Grouped scatter</b> · <code>babel</code></sub>
</td>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/multi_line"><img src="man/figures/showcase/showcase-line.webp" alt="Grouped line chart using walter_white2" width="100%" /></a><br />
  <sub><b>Multi-line comparison</b> · <code>walter_white2</code></sub>
</td>
</tr>
<tr>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/correlation_heatmap"><img src="man/figures/showcase/showcase-heatmap.webp" alt="Correlation heatmap using walter_white" width="100%" /></a><br />
  <sub><b>Correlation heatmap</b> · <code>walter_white</code></sub>
</td>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/bar"><img src="man/figures/showcase/showcase-stacked.webp" alt="Eye color composition by hair color using lactate_steps" width="100%" /></a><br />
  <sub><b>Eye color composition by hair color</b> · <code>lactate_steps</code></sub>
</td>
</tr>
<tr>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/survival_curve"><img src="man/figures/showcase/showcase-survival.webp" alt="Kaplan-Meier survival curve using heat_light" width="100%" /></a><br />
  <sub><b>Kaplan–Meier survival curve</b> · <code>heat_light</code></sub>
</td>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/manhattan"><img src="man/figures/showcase/showcase-manhattan.webp" alt="Manhattan plot using cancer_mosaic" width="100%" /></a><br />
  <sub><b>Manhattan plot</b> · <code>cancer_mosaic</code></sub>
</td>
</tr>
</table>

## License

MIT License © 2025–2026 Yibin Zhou
