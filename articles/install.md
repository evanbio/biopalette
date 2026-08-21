# Installing biopalette

## Requirements

biopalette requires R 4.1 or later. It works on Windows, macOS, and
Linux and does not contain compiled code.

The package uses four runtime dependencies:

- **cli** for user-facing messages;
- **ggplot2** for previews, galleries, and scales;
- **jsonlite** for reading and writing palette collections;
- **scales** for continuous color interpolation.

R installs these dependencies automatically when biopalette is
installed.

## Install from GitHub

The development version is available from GitHub. We recommend
[pak](https://pak.r-lib.org/) because it resolves dependencies and
reports installation problems clearly.

``` r

install.packages("pak")
pak::pkg_install("evanbio/biopalette")
```

Alternatively, install with remotes:

``` r

install.packages("remotes")
remotes::install_github("evanbio/biopalette")
```

You only need to install `pak` or `remotes` once.

## Verify the installation

Load the package, inspect its version, and list a few bundled palettes:

``` r

library(biopalette)

packageVersion("biopalette")
#> [1] '0.2.0'
head(list_palettes()[c("name", "type", "n_color")])
#>            name        type n_color
#> 1  bcell_atlas2   diverging       5
#> 2  walter_white   diverging       5
#> 3 walter_white3   diverging       5
#> 4      gene_red qualitative       2
#> 5    heat_light qualitative       2
#> 6    three_body qualitative       3
```

For a visual check, open the palette gallery in an interactive R
session:

``` r

palette_gallery()
```

## Update

Run the same GitHub installation command to update to the latest
development version:

``` r

pak::pkg_install("evanbio/biopalette")
```

Restart R after updating if biopalette was loaded in the current
session. This ensures that R uses the newly installed namespace and
package files.

## Troubleshooting

### R cannot install a dependency

Start a fresh R session and retry the installation. If the error
identifies a specific dependency, install that package directly to
expose its complete error message:

``` r

install.packages("packageName")
```

biopalette itself does not require compilation. On Windows, Rtools is
needed only when R must install a dependency from source and that
dependency contains compiled code. Install the version of
[Rtools](https://cran.r-project.org/bin/windows/Rtools/) that matches
your R version if the error explicitly says that build tools are
required.

### GitHub cannot be reached

Confirm that the repository is accessible in a web browser and that R
can connect to GitHub. On managed institutional networks, use the proxy
or certificate settings supplied by your system administrator; do not
place credentials in scripts committed to version control.

### R loads an older version

Check the installed version and library location:

``` r

packageVersion("biopalette")
find.package("biopalette")
.libPaths()
```

Multiple R libraries can contain different copies of the package. Remove
the older copy from the library reported by
[`find.package()`](https://rdrr.io/r/base/find.package.html) or install
the update into that library.

## Uninstall

``` r

remove.packages("biopalette")
```

If more than one library contains biopalette, pass the relevant library
path through the `lib` argument of
[`remove.packages()`](https://rdrr.io/r/utils/remove.packages.html).

## Where to begin

After installation:

- open
  [`vignette("get-started", package = "biopalette")`](https://evanbio.github.io/biopalette/articles/get-started.md)
  for the core R workflow;
- open
  [`vignette("palette", package = "biopalette")`](https://evanbio.github.io/biopalette/articles/palette.md)
  to browse the palettes included with the package;
- open
  [`vignette("tessera", package = "biopalette")`](https://evanbio.github.io/biopalette/articles/tessera.md)
  to continue from palette discovery to example data and complete R
  figure recipes.

## Getting help

- Read the [package
  documentation](https://evanbio.github.io/biopalette/).
- Report reproducible problems in [GitHub
  Issues](https://github.com/evanbio/biopalette/issues).

When reporting an installation problem, include the complete error
message and the output of
[`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html). Remove
tokens, passwords, user names, and other sensitive paths before posting
the output publicly.
