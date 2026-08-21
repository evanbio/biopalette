# Discrete ggplot2 Scales from a biopalette Palette

Use a named biopalette palette for a discrete colour or fill mapping.
The scale asks
[`get_palette()`](https://evanbio.github.io/biopalette/reference/get_palette.md)
for exactly as many colours as the trained data has levels. Qualitative
palettes therefore use their first `n` colours, while sequential and
diverging palettes sample `n` colours across their complete ramps.

## Usage

``` r
scale_color_biopalette(
  palette,
  ...,
  type = NULL,
  reverse = FALSE,
  palettes_dir = NULL
)

scale_colour_biopalette(
  palette,
  ...,
  type = NULL,
  reverse = FALSE,
  palettes_dir = NULL
)

scale_fill_biopalette(
  palette,
  ...,
  type = NULL,
  reverse = FALSE,
  palettes_dir = NULL
)
```

## Arguments

- palette:

  Character. Name of the palette.

- ...:

  Passed to
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html),
  for example `name`, `breaks`, `labels`, `limits`, `na.value`, `drop`,
  and `guide`.

- type:

  Character. One of `"sequential"`, `"diverging"`, or `"qualitative"`.
  If `NULL`, the type is detected automatically.

- reverse:

  Logical. Reverse the palette. Default: `FALSE`.

- palettes_dir:

  Character. Directory holding a palette collection. If `NULL`, the
  palettes bundled with the package are used.

## Value

A ggplot2 discrete scale.

## Details

All three palette types are supported. Qualitative palettes suit
unordered categories; sequential and diverging palettes can be useful
for ordered categories.

## Examples

``` r
library(ggplot2)

ggplot(iris, aes(Sepal.Length, Sepal.Width, colour = Species)) +
  geom_point() +
  scale_color_biopalette("three_body")


ggplot(iris, aes(Species, Sepal.Length, fill = Species)) +
  geom_boxplot() +
  scale_fill_biopalette("three_body", guide = "none")

```
