# Continuous ggplot2 Gradients from a biopalette Palette

Build a continuous colour or fill gradient from a sequential or
diverging biopalette palette. The complete palette supplies the gradient
stops to
[`ggplot2::scale_colour_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
or
[`ggplot2::scale_fill_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html).
Gradients are interpolated in Lab colour space, the same space used when
[`get_palette()`](https://evanbio.github.io/biopalette/reference/get_palette.md)
resamples sequential and diverging palettes.

## Usage

``` r
scale_color_biopalette_gradient(
  palette,
  ...,
  type = NULL,
  reverse = FALSE,
  values = NULL,
  midpoint = NULL,
  transform = "identity",
  palettes_dir = NULL
)

scale_colour_biopalette_gradient(
  palette,
  ...,
  type = NULL,
  reverse = FALSE,
  values = NULL,
  midpoint = NULL,
  transform = "identity",
  palettes_dir = NULL
)

scale_fill_biopalette_gradient(
  palette,
  ...,
  type = NULL,
  reverse = FALSE,
  values = NULL,
  midpoint = NULL,
  transform = "identity",
  palettes_dir = NULL
)
```

## Arguments

- palette:

  Character. Name of the palette.

- ...:

  Passed to
  [`ggplot2::scale_colour_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
  or
  [`ggplot2::scale_fill_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html),
  for example `name`, `breaks`, `labels`, `limits`, `transform`,
  `na.value`, and `guide`.

- type:

  Character. `"sequential"` or `"diverging"`. If `NULL`, the type is
  detected automatically.

- reverse:

  Logical. Reverse the palette. When `values` is supplied, its spacing
  is reversed with the colours. Default: `FALSE`.

- values:

  Optional numeric positions for the palette colours, as accepted by
  [`ggplot2::scale_colour_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html).
  Must have one value per palette colour, be non-decreasing, and lie in
  `[0, 1]`.

- midpoint:

  Optional finite numeric value to place at the visual centre of a
  diverging palette. Values are rescaled with equal units on either side
  of this point, so the shorter side of an asymmetric data range does
  not reach the palette's extreme colour. `midpoint` cannot be combined
  with `values` or a custom `rescaler`. The default, `NULL`, applies
  ordinary range-based scaling.

- transform:

  A transformation specification accepted by
  [`ggplot2::continuous_scale()`](https://ggplot2.tidyverse.org/reference/continuous_scale.html).
  The same transformation is applied to `midpoint` before the gradient
  is rescaled, so the centre remains correct under transformations such
  as `"log10"`. Default: `"identity"`.

- palettes_dir:

  Character. Directory holding a palette collection. If `NULL`, the
  palettes bundled with the package are used.

## Value

A ggplot2 continuous scale.

## Details

Qualitative palettes are rejected because interpolating unordered
category colours does not produce a meaningful continuous scale. Use
[`scale_color_biopalette()`](https://evanbio.github.io/biopalette/reference/scale_color_biopalette.md)
or
[`scale_fill_biopalette()`](https://evanbio.github.io/biopalette/reference/scale_color_biopalette.md)
for those palettes.

## Examples

``` r
library(ggplot2)

ggplot(mtcars, aes(wt, mpg, colour = hp)) +
  geom_point(size = 3) +
  scale_color_biopalette_gradient("mitonuclear_blue")


ggplot(mtcars, aes(factor(cyl), factor(gear), fill = mpg - mean(mpg))) +
  geom_tile() +
  scale_fill_biopalette_gradient("walter_white", midpoint = 0)

```
