# Get a Color Palette

Retrieve a named palette by name and type, returning a vector of HEX
colors. Automatically checks for type mismatch and provides smart
suggestions.

## Usage

``` r
get_palette(name, type = NULL, n = NULL, palettes_path = NULL)
```

## Arguments

- name:

  Character. Name of the palette (e.g. "qual_vivid").

- type:

  Character. One of "sequential", "diverging", "qualitative". If NULL,
  type is auto-detected.

- n:

  Integer. Number of colors to return. If NULL, returns all colors.
  Default is NULL.

- palettes_path:

  Character. Path to a `palettes.rda` file. If NULL, uses the installed
  package dataset.

## Value

Character vector of HEX color codes.

## Examples

``` r
get_palette("gene_red", type = "qualitative")
#> [1] "#000000" "#B11522"
get_palette("walter_white2", type = "qualitative", n = 2)
#> [1] "#5AB5BF" "#808C56"
get_palette("walter_white", type = "diverging")
#> [1] "#1991A9" "#A3C5C4" "#E7E9E4" "#A9B688" "#495A2E"
```
