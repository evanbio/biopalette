# Convert HEX Colors to RGB

Convert a character vector of HEX color codes to a data.frame with
columns `hex`, `r`, `g`, `b`, and `alpha`.

## Usage

``` r
hex2rgb(hex)
```

## Arguments

- hex:

  Character vector of HEX color codes (e.g. `"#FF8000"` or
  `"#FF8000B2"`). Both 6-digit and 8-digit (with alpha) codes are
  accepted. The `#` prefix is required. No NA values allowed.

## Value

A data.frame with `hex` (character) and integer `r`, `g`, `b`, and
`alpha` columns. Channels lie in `[0, 255]`. `alpha` is `NA_integer_`
for a 6-digit input and the explicit alpha channel for an 8-digit input.

## Examples

``` r
hex2rgb("#FF8000")
#>       hex   r   g b alpha
#> 1 #FF8000 255 128 0    NA
hex2rgb(c("#FF8000", "#00FF00"))
#>       hex   r   g b alpha
#> 1 #FF8000 255 128 0    NA
#> 2 #00FF00   0 255 0    NA
```
