# Installation Guide

## Quick Install

``` r

# Using pak (recommended)
install.packages("pak")
pak::pkg_install("evanbio/biopalette")

# Using remotes
install.packages("remotes")
remotes::install_github("evanbio/biopalette")
```

**Requires:** R ≥ 4.1.0

------------------------------------------------------------------------

## Dependencies

All dependencies are installed automatically with the package.

- **cli** — User-facing messages and warnings
- **ggplot2** — Palette preview rendering
- **jsonlite** — JSON read/write for palette storage

------------------------------------------------------------------------

## Verify Installation

``` r

library(biopalette)

packageVersion("biopalette")
#> [1] '0.1.0'
list_palettes()
#>                 name        type n_color       colors
#> 1       walter_white   diverging       5 #1991A9,....
#> 2      walter_white3   diverging       5 #B15F63,....
#> 3           gene_red qualitative       2 #000000,....
#> 4         three_body qualitative       3 #6495ED,....
#> 5      walter_white2 qualitative       5 #5AB5BF,....
#> 6              babel qualitative      21 #1688A7,....
#> 7   mitonuclear_blue  sequential       6 #EEF4FB,....
#> 8 mitonuclear_orange  sequential       6 #F8E7E3,....
```

------------------------------------------------------------------------

## Update

``` r

pak::pkg_install("evanbio/biopalette")
```

------------------------------------------------------------------------

## Troubleshooting

### Installation fails on Windows

Install [Rtools](https://cran.r-project.org/bin/windows/Rtools/) for
packages that require compilation, then retry.

### Network / Firewall issues

``` r

Sys.setenv(http_proxy  = "http://your-proxy:port")
Sys.setenv(https_proxy = "https://your-proxy:port")
```

------------------------------------------------------------------------

## Uninstall

``` r

remove.packages("biopalette")
```

------------------------------------------------------------------------

## Getting Help

- **Documentation**: <https://evanbio.github.io/biopalette/>
- **Issues**: [GitHub
  Issues](https://github.com/evanbio/biopalette/issues)
