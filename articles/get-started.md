# Get Started with biopalette

## Overview

**biopalette** provides color palettes for biomedical visualization,
each sourced from a real image. This guide covers the core workflow:
browsing, retrieving, previewing, and using palettes in plots.

## Installation

``` r
pak::pkg_install("evanbio/biopalette")
```

## Browse Available Palettes

``` r
library(biopalette)

list_palettes()
palette_gallery()
```

[`list_palettes()`](https://evanbio.github.io/biopalette/reference/list_palettes.md)
returns a data frame of all available palettes with their name, type,
and number of colors.
[`palette_gallery()`](https://evanbio.github.io/biopalette/reference/palette_gallery.md)
renders a visual overview.

## Retrieve Colors

``` r
# Full palette
get_palette("babel")

# First n colors
get_palette("babel", n = 5)

# Specify type for disambiguation
get_palette("walter_white", type = "diverging")
```

The returned value is a named character vector of HEX codes, ready to
pass to any plotting function.

## Preview a Palette

``` r
preview_palette("gene_red")
preview_palette("babel", plot_type = "rect")
preview_palette("three_body", plot_type = "circle")
```

## Use in ggplot2

``` r
library(ggplot2)

cols <- get_palette("three_body")

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 2) +
  scale_color_manual(values = cols)
```

For continuous scales, pass colors directly to
[`scale_fill_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
or
[`scale_color_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html):

``` r
cols <- get_palette("walter_white")

ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  scale_fill_gradientn(colors = cols)
```

## Color Utilities

``` r
hex2rgb("#1688A7")
rgb2hex(22, 136, 167)
```

## Function Reference

| Function                                                                                   | Purpose                                 |
|--------------------------------------------------------------------------------------------|-----------------------------------------|
| [`list_palettes()`](https://evanbio.github.io/biopalette/reference/list_palettes.md)       | Data frame of all available palettes    |
| [`palette_gallery()`](https://evanbio.github.io/biopalette/reference/palette_gallery.md)   | Visual gallery of all palettes          |
| [`get_palette()`](https://evanbio.github.io/biopalette/reference/get_palette.md)           | Retrieve colors by name, type, and size |
| [`preview_palette()`](https://evanbio.github.io/biopalette/reference/preview_palette.md)   | Render color swatches                   |
| [`create_palette()`](https://evanbio.github.io/biopalette/reference/create_palette.md)     | Add a new palette                       |
| [`compile_palettes()`](https://evanbio.github.io/biopalette/reference/compile_palettes.md) | Compile all JSONs into a named list     |
| [`remove_palette()`](https://evanbio.github.io/biopalette/reference/remove_palette.md)     | Remove a palette by name                |
| [`hex2rgb()`](https://evanbio.github.io/biopalette/reference/hex2rgb.md)                   | HEX to RGB                              |
| [`rgb2hex()`](https://evanbio.github.io/biopalette/reference/rgb2hex.md)                   | RGB to HEX                              |

## Getting Help

- **Documentation**: <https://evanbio.github.io/biopalette/>
- **Issues**: [GitHub
  Issues](https://github.com/evanbio/biopalette/issues)
- **Function help**:
  [`?get_palette`](https://evanbio.github.io/biopalette/reference/get_palette.md),
  [`?preview_palette`](https://evanbio.github.io/biopalette/reference/preview_palette.md)
