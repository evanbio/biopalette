# Built-in color palettes

A compiled list of all built-in color palettes, organized by type.
Generated from JSON source files in `inst/extdata/palettes/` via
`data-raw/palettes.R`.

## Usage

``` r
palettes
```

## Format

A named list with three elements:

- sequential:

  Named list of sequential palettes; each element is a character vector
  of HEX color codes.

- diverging:

  Named list of diverging palettes; each element is a character vector
  of HEX color codes.

- qualitative:

  Named list of qualitative palettes; each element is a character vector
  of HEX color codes.

## Source

`data-raw/palettes.R`

## Examples

``` r
names(palettes)
#> [1] "sequential"  "diverging"   "qualitative"
names(palettes$qualitative)
#> [1] "babel"         "cancer_mosaic" "gene_red"      "heat_light"   
#> [5] "lactate_steps" "tam_pastel"    "three_body"    "walter_white2"
palettes$qualitative$gene_red
#> [1] "#000000" "#B11522"
```
