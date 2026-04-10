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
list_palettes()
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
