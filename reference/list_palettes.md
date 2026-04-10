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
#>                        name        type n_color       colors
#> walter_white   walter_white   diverging       5 #1991A9,....
#> walter_white3 walter_white3   diverging       5 #B15F63,....
#> gene_red           gene_red qualitative       2 #000000,....
#> three_body       three_body qualitative       3 #6495ED,....
#> walter_white2 walter_white2 qualitative       5 #5AB5BF,....
#> babel                 babel qualitative      21 #1688A7,....
list_palettes(type = "qualitative")
#>                        name        type n_color       colors
#> gene_red           gene_red qualitative       2 #000000,....
#> three_body       three_body qualitative       3 #6495ED,....
#> walter_white2 walter_white2 qualitative       5 #5AB5BF,....
#> babel                 babel qualitative      21 #1688A7,....
list_palettes(type = c("sequential", "diverging"))
#>                        name      type n_color       colors
#> walter_white   walter_white diverging       5 #1991A9,....
#> walter_white3 walter_white3 diverging       5 #B15F63,....
```
