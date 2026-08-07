# List Available Color Palettes

Return a data.frame of all available palette metadata, optionally
filtered by type.

## Usage

``` r
list_palettes(type = NULL, sort = TRUE, palettes_path = NULL)
```

## Arguments

- type:

  Palette type(s) to filter: `"sequential"`, `"diverging"`,
  `"qualitative"`. Default NULL returns all.

- sort:

  Whether to sort by type, n_color, name. Default: TRUE.

- palettes_path:

  Character. Path to a `palettes.rda` file. If NULL, uses the installed
  package dataset.

## Value

A `data.frame` with columns: `name`, `type`, `n_color`, `colors`.

## Examples

``` r
list_palettes()
#>            name        type n_color       colors
#> 1  walter_white   diverging       5 #1991A9,....
#> 2 walter_white3   diverging       5 #B15F63,....
#> 3      gene_red qualitative       2 #000000,....
#> 4    three_body qualitative       3 #6495ED,....
#> 5 walter_white2 qualitative       5 #5AB5BF,....
#> 6         babel qualitative      21 #1688A7,....
list_palettes(type = "qualitative")
#>            name        type n_color       colors
#> 1      gene_red qualitative       2 #000000,....
#> 2    three_body qualitative       3 #6495ED,....
#> 3 walter_white2 qualitative       5 #5AB5BF,....
#> 4         babel qualitative      21 #1688A7,....
list_palettes(type = c("sequential", "diverging"))
#>            name      type n_color       colors
#> 1  walter_white diverging       5 #1991A9,....
#> 2 walter_white3 diverging       5 #B15F63,....
```
