# Visualize All Palettes in a Gallery View

Display palettes in a paged gallery format, returning a named list of
ggplot objects.

## Usage

``` r
palette_gallery(
  type = NULL,
  max_palettes = 30,
  max_row = 12,
  verbose = TRUE,
  palettes_path = NULL
)
```

## Arguments

- type:

  Palette types to include: "sequential", "diverging", "qualitative".
  Default NULL returns all.

- max_palettes:

  Number of palettes per page. Default: 30.

- max_row:

  Max colors per row. Default: 12.

- verbose:

  Whether to print progress info. Default: TRUE.

- palettes_path:

  Character. Path to a `palettes.rda` file. If NULL, uses the installed
  package dataset.

## Value

A named list of ggplot objects (one per page).

## Examples

``` r
# \donttest{
palette_gallery()
#> ℹ Type diverging: 2 palettes -> 1 page(s)
#> ✔ Built "diverging_page1"
#> ℹ Type qualitative: 4 palettes -> 1 page(s)
#> ✔ Built "qualitative_page1"
#> $diverging_page1

#> 
#> $qualitative_page1

#> 
palette_gallery(type = "qualitative")
#> ℹ Type qualitative: 4 palettes -> 1 page(s)
#> ✔ Built "qualitative_page1"
#> $qualitative_page1

#> 
palette_gallery(type = c("sequential", "diverging"), max_palettes = 10)
#> ℹ Type diverging: 2 palettes -> 1 page(s)
#> ✔ Built "diverging_page1"
#> $diverging_page1

#> 
# }
```
