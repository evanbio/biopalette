# Compile JSON Palettes into a Palette List

Read JSON files under `palettes_dir/`, validate content, and return a
structured list of palettes. Used by `data-raw/palettes.R` to build the
package dataset via `usethis::use_data()`.

## Usage

``` r
compile_palettes(palettes_dir)
```

## Arguments

- palettes_dir:

  Character. Folder containing subdirs: sequential/, diverging/,
  qualitative/.

## Value

Invisibly returns a named list with elements `sequential`, `diverging`,
`qualitative`.

## Examples

``` r
# \donttest{
compile_palettes(
  palettes_dir = system.file("extdata", "palettes", package = "biopalette")
)
#> ✔ Compiled 6 palettes: Sequential=0, Diverging=2, Qualitative=4
# }
```
