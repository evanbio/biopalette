# Convert RGB Values to HEX Color Codes

Convert RGB or RGBA values to HEX color codes. Accepts either a numeric
vector or a data.frame, symmetrically with
[`hex2rgb()`](https://evanbio.github.io/biopalette/reference/hex2rgb.md).

## Usage

``` r
rgb2hex(rgb)
```

## Arguments

- rgb:

  A numeric vector of length 3 (`r`, `g`, `b`) or 4 (`r`, `g`, `b`,
  `alpha`), or a data.frame with `r`, `g`, `b`, and optional `alpha`
  columns. Matrices and arrays are not accepted. Values must lie in
  `[0, 255]` and are rounded to the nearest integer, with exact halves
  rounded up. In a data.frame, `alpha = NA` emits 6-digit HEX; a finite
  alpha value emits 8-digit HEX. Data frames must contain at least one
  row; unrelated extra columns are ignored.

## Value

A character vector of uppercase 6- or 8-digit HEX color codes.

## Examples

``` r
rgb2hex(c(255, 128, 0))
#> [1] "#FF8000"
rgb2hex(c(255, 128, 0, 178))
#> [1] "#FF8000B2"
rgb2hex(hex2rgb(c("#FF8000", "#00FF0080")))
#> [1] "#FF8000"   "#00FF0080"
```
