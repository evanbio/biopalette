# Preview a Color Palette

Visualize a palette using various plot styles.

## Usage

``` r
preview_palette(
  name,
  type = NULL,
  n = NULL,
  reverse = FALSE,
  plot_type = c("bar", "pie", "point", "rect", "circle"),
  title = NULL,
  palettes_dir = NULL
)
```

## Arguments

- name:

  Character. Name of the palette.

- type:

  Character. One of "sequential", "diverging", "qualitative". If NULL,
  auto-detected.

- n:

  Integer. Number of colors to use. If NULL, uses all. Default: NULL.

- reverse:

  Logical. Reverse the palette before `n` is applied. Passed straight
  through to
  [`get_palette()`](https://evanbio.github.io/biopalette/reference/get_palette.md).
  Default: FALSE.

- plot_type:

  Character. One of "bar", "pie", "point", "rect", "circle". Default:
  "bar".

- title:

  Character. Plot title. If NULL, defaults to palette name.

- palettes_dir:

  Character. Directory holding a palette collection (`sequential/`,
  `diverging/`, `qualitative/` subdirectories of JSON files). If NULL,
  the palettes bundled with the package are used.

## Value

`NULL`, invisibly. Called for its plotting side effect — the return
shape is the same for every `plot_type`.

## Details

`"bar"`, `"pie"`, `"point"` and `"circle"` are drawn with base graphics;
`"rect"` is drawn with ggplot2. Either way the plot goes straight to the
active device and nothing is returned — use
[`palette_gallery()`](https://evanbio.github.io/biopalette/reference/palette_gallery.md)
when you want plot objects you can modify, arrange or save.

## See also

[`palette_gallery()`](https://evanbio.github.io/biopalette/reference/palette_gallery.md),
which returns ggplot objects instead of drawing.

## Examples

``` r
# \donttest{
preview_palette("gene_red", plot_type = "bar")

preview_palette("walter_white", plot_type = "pie")

preview_palette("walter_white2", n = 2, plot_type = "circle")

# }
```
