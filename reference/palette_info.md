# Get Metadata for One Color Palette

Return the runtime metadata for a single named palette. This is the
one-palette counterpart to
[`list_palettes()`](https://evanbio.github.io/biopalette/reference/list_palettes.md)
and uses the same lookup rules as
[`get_palette()`](https://evanbio.github.io/biopalette/reference/get_palette.md).

## Usage

``` r
palette_info(name, type = NULL, palettes_dir = NULL)
```

## Arguments

- name:

  Character. Palette name.

- type:

  Character. One of `"sequential"`, `"diverging"`, or `"qualitative"`.
  If `NULL`, the type is detected automatically.

- palettes_dir:

  Character. Directory holding a palette collection. If `NULL`, the
  palettes bundled with the package are used.

## Value

A one-row data.frame with columns `name`, `type`, `n_color`, and
`colors`. The `colors` column is a list-column containing the complete
HEX color vector.

## Examples

``` r
palette_info("walter_white")
#>           name      type n_color       colors
#> 1 walter_white diverging       5 #1991A9,....
palette_info("babel", type = "qualitative")
#>    name        type n_color       colors
#> 1 babel qualitative      21 #1688A7,....
```
