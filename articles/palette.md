# Color Palette Management

## Overview

The palette module provides nine functions covering four areas:

| Area              | Functions                                                                                                                                                                                                                                                                  |
|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Querying palettes | [`get_palette()`](https://evanbio.github.io/biopalette/reference/get_palette.md), [`list_palettes()`](https://evanbio.github.io/biopalette/reference/list_palettes.md)                                                                                                     |
| Visualization     | [`preview_palette()`](https://evanbio.github.io/biopalette/reference/preview_palette.md), [`palette_gallery()`](https://evanbio.github.io/biopalette/reference/palette_gallery.md)                                                                                         |
| Managing palettes | [`create_palette()`](https://evanbio.github.io/biopalette/reference/create_palette.md), [`remove_palette()`](https://evanbio.github.io/biopalette/reference/remove_palette.md), [`compile_palettes()`](https://evanbio.github.io/biopalette/reference/compile_palettes.md) |
| Color conversion  | [`hex2rgb()`](https://evanbio.github.io/biopalette/reference/hex2rgb.md), [`rgb2hex()`](https://evanbio.github.io/biopalette/reference/rgb2hex.md)                                                                                                                         |

``` r
library(biopalette)
```

> **Note:** All code examples in this vignette are static
> (`eval = FALSE`). Output is hand-written to reflect the current
> implementation. If you modify the palette functions, re-verify the
> examples manually or switch chunks to `eval = TRUE`.

Palettes are stored as JSON files organized under three subdirectories —
`sequential/`, `diverging/`, and `qualitative/` — and compiled into the
`palettes` package dataset via
[`compile_palettes()`](https://evanbio.github.io/biopalette/reference/compile_palettes.md).

------------------------------------------------------------------------

## 1 Querying Palettes

### `get_palette()` — Retrieve a palette by name

Returns a character vector of HEX color codes. If `type` is omitted, the
palette type is auto-detected. Use `n` to take the first N colors from a
larger palette.

``` r
# Auto-detect type
get_palette("babel")
#> [1] "#1688A7" "#7673AE" "#B3DE69" "#D195F6" "#7E285E" ...

# Specify type explicitly
get_palette("babel", type = "qualitative")
#> [1] "#1688A7" "#7673AE" "#B3DE69" "#D195F6" "#7E285E" ...

# Take only the first 5 colors
get_palette("babel", type = "qualitative", n = 5)
#> [1] "#1688A7" "#7673AE" "#B3DE69" "#D195F6" "#7E285E"
```

When `type` is wrong, the error message tells you where the palette
actually lives:

``` r
get_palette("walter_white", type = "qualitative")
#> Error in `get_palette()`:
#> ! Palette "walter_white" not found under "qualitative", but exists under "diverging".
#> Try: get_palette("walter_white", type = "diverging")
```

Requesting more colors than the palette contains raises an informative
error rather than silently recycling:

``` r
get_palette("gene_red", type = "qualitative", n = 5)
#> Error in `get_palette()`:
#> ! Palette "gene_red" only has 2 colors, but requested 5.
```

------------------------------------------------------------------------

### `list_palettes()` — Browse available palettes

Returns a data frame with columns `name`, `type`, `n_color`, and
`colors`. Filter by one or more types with the `type` argument.

``` r
list_palettes()
#>           name       type n_color                               colors
#> 1     gene_red qualitative       2                    #000000, #B11522
#> 2        babel qualitative      21  #1688A7, #7673AE, #B3DE69, ...
#> 3   three_body qualitative       3         #6495ED, #339933, #FF4500
#> 4 walter_white   diverging       5  #1991A9, #A3C5C4, #E7E9E4, ...
#> ...
```

``` r
# Single type
list_palettes(type = "qualitative")

# Multiple types
list_palettes(type = c("sequential", "diverging"))
```

Results are sorted by `type`, `n_color`, and `name` by default. Set
`sort = FALSE` to keep the original file order.

------------------------------------------------------------------------

## 2 Visualization

### `preview_palette()` — Visualize a single palette

Plots a single palette using one of five styles: `"bar"` (default),
`"pie"`, `"point"`, `"rect"`, or `"circle"`. Returns `NULL` invisibly —
called for the plotting side effect.

``` r
preview_palette("gene_red")
preview_palette("walter_white", type = "diverging", plot_type = "pie")
preview_palette("three_body", n = 3, plot_type = "circle")
```

Supply `title` to override the default title (which is the palette
name):

``` r
preview_palette("babel", title = "Pan-cancer myeloid cell types")
```

------------------------------------------------------------------------

### `palette_gallery()` — Browse all palettes at once

Renders a paged gallery of all palettes and returns a named list of
ggplot objects (one per page). Useful for picking colors interactively.

``` r
plots <- palette_gallery()
#> i Type diverging: 2 palettes -> 1 page(s)
#> v Built "diverging_page1"
#> i Type qualitative: 4 palettes -> 1 page(s)
#> v Built "qualitative_page1"
```

Filter by type and control how many palettes appear per page:

``` r
plots <- palette_gallery(type = "qualitative")
plots <- palette_gallery(type = c("qualitative", "diverging"), max_palettes = 3)
```

Access individual pages from the returned list:

``` r
plots[["qualitative_page1"]]
```

Set `verbose = FALSE` to suppress progress messages when calling
[`palette_gallery()`](https://evanbio.github.io/biopalette/reference/palette_gallery.md)
programmatically.

------------------------------------------------------------------------

## 3 Managing Palettes

### `create_palette()` — Save a custom palette

Writes a named palette as a JSON file under
`color_dir/<type>/<name>.json`. The directory is created automatically
if it does not exist.

``` r
temp_dir <- file.path(tempdir(), "palettes")

create_palette("my_blues", "sequential", c("#deebf7", "#9ecae1", "#3182bd"),
               color_dir = temp_dir)
#> v Palette saved: /tmp/.../palettes/sequential/my_blues.json

create_palette("my_trio", "qualitative",
               c("#E64B35", "#4DBBD5", "#00A087"),
               color_dir = temp_dir)
#> v Palette saved: /tmp/.../palettes/qualitative/my_trio.json
```

By default, saving over an existing name raises an error. Pass
`overwrite = TRUE` to replace it:

``` r
create_palette("my_blues", "sequential", c("#c6dbef", "#6baed6", "#2171b5"),
               color_dir = temp_dir, overwrite = TRUE)
#> i Overwriting existing palette: "my_blues"
#> v Palette saved: /tmp/.../palettes/sequential/my_blues.json
```

``` r
# Without overwrite = TRUE
create_palette("my_blues", "sequential", c("#deebf7", "#9ecae1", "#3182bd"),
               color_dir = temp_dir)
#> Error in `create_palette()`:
#> ! Palette "my_blues" already exists. Use `overwrite = TRUE` to replace.
```

The function invisibly returns a list with `path` and `info` so the
result can be captured when needed.

------------------------------------------------------------------------

### `remove_palette()` — Delete a palette JSON

Removes a palette JSON file by name. If `type` is omitted, all three
type directories are searched in order.

``` r
remove_palette("my_blues", color_dir = temp_dir)
#> v Removed "my_blues" from sequential

# Specify type to skip the search
remove_palette("my_trio", type = "qualitative", color_dir = temp_dir)
#> v Removed "my_trio" from qualitative
```

If the palette is not found in any directory, a warning is issued and
the function returns `FALSE` invisibly:

``` r
remove_palette("nonexistent", color_dir = temp_dir)
#> ! Palette "nonexistent" not found in any type.
```

------------------------------------------------------------------------

### `compile_palettes()` — Build the palette dataset

Reads all JSON files under `palettes_dir/sequential/`,
`palettes_dir/diverging/`, and `palettes_dir/qualitative/`, validates
them, and returns a structured list. This is the function used in
`data-raw/palettes.R` to rebuild the `palettes` package dataset via
`usethis::use_data()`.

``` r
compiled <- compile_palettes(
  palettes_dir = system.file("extdata", "palettes", package = "biopalette")
)
#> v Compiled 6 palettes: Sequential=0, Diverging=2, Qualitative=4
```

The return value is a named list with three elements — `sequential`,
`diverging`, and `qualitative` — each of which is a named list of HEX
vectors:

``` r
compiled$qualitative[["babel"]]
#> [1] "#1688A7" "#7673AE" "#B3DE69" "#D195F6" "#7E285E" ...
```

> Duplicate palette names within the same type emit a warning and the
> last file read wins. JSON files with missing or invalid fields are
> skipped with a warning rather than aborting the whole compile.

------------------------------------------------------------------------

## 4 Color Conversion

### `hex2rgb()` — HEX to RGB data frame

Converts a character vector of HEX codes to a data frame with columns
`hex`, `r`, `g`, `b`. Both 6-digit (`#RRGGBB`) and 8-digit (`#RRGGBBAA`)
codes are accepted; the alpha channel is silently ignored.

``` r
hex2rgb("#1688A7")
#>       hex   r   g   b
#> 1 #1688A7  22 136 167

hex2rgb(c("#1688A7", "#FF4500", "#339933"))
#>       hex   r   g   b
#> 1 #1688A7  22 136 167
#> 2 #FF4500 255  69   0
#> 3 #339933  51 153  51
```

The `#` prefix is required; codes that fail the pattern and `NA` values
are both reported as invalid:

``` r
# Missing '#' prefix
hex2rgb("1688A7")
#> Error in `hex2rgb()`:
#> ! `hex` contains invalid HEX codes: "1688A7".

# NA is treated as an invalid code
hex2rgb(c("#1688A7", NA))
#> Error in `hex2rgb()`:
#> ! `hex` contains invalid HEX codes: NA.
```

------------------------------------------------------------------------

### `rgb2hex()` — RGB to HEX color codes

The symmetric counterpart to
[`hex2rgb()`](https://evanbio.github.io/biopalette/reference/hex2rgb.md).
Accepts either a numeric vector of length 3 or the data frame returned
by
[`hex2rgb()`](https://evanbio.github.io/biopalette/reference/hex2rgb.md).
Non-integer values are rounded before conversion.

``` r
# Single color as a length-3 vector
rgb2hex(c(22, 136, 167))
#> [1] "#1688A7"
```

``` r
# Round-trip: HEX -> RGB -> HEX
rgb2hex(hex2rgb(c("#1688A7", "#FF4500")))
#> [1] "#1688A7" "#FF4500"
```

``` r
# Non-integer values are rounded
rgb2hex(c(21.7, 136.2, 167.4))
#> [1] "#1688A7"
```

Typical failure cases for the vector form:

``` r
# Wrong length
rgb2hex(c(22, 136))
#> Error in `rgb2hex()`:
#> ! `rgb` must be a numeric vector of length 3.

# Value out of range
rgb2hex(c(22, 136, 300))
#> Error in `rgb2hex()`:
#> ! `rgb` values must be in [0, 255].
```

And for the data frame form:

``` r
# Missing column
rgb2hex(data.frame(r = 22, g = 136))
#> Error in `rgb2hex()`:
#> ! `rgb` must have columns {"r", "g", "b"}. Missing: {"b"}.

# Column value out of range
rgb2hex(data.frame(r = 22, g = 136, b = 300))
#> Error in `rgb2hex()`:
#> ! Column "b" in `rgb` must be numeric with values in [0, 255].
```

------------------------------------------------------------------------

## 5 A Combined Workflow

The palette and conversion functions compose naturally. The example
below picks a qualitative palette, converts its colors to RGB for
downstream processing, then round-trips back to HEX to verify no
information was lost.

``` r
library(biopalette)

# 1. Retrieve a qualitative palette
colors <- get_palette("three_body", type = "qualitative")
colors
#> [1] "#6495ED" "#339933" "#FF4500"

# 2. Convert to RGB for numeric manipulation
rgb_df <- hex2rgb(colors)
rgb_df
#>       hex   r   g   b
#> 1 #6495ED 100 149 237
#> 2 #339933  51 153  51
#> 3 #FF4500 255  69   0

# 3. Lighten each color by blending 50% toward white (255)
rgb_light <- rgb_df
rgb_light$r <- (rgb_light$r + 255) / 2
rgb_light$g <- (rgb_light$g + 255) / 2
rgb_light$b <- (rgb_light$b + 255) / 2

# 4. Convert back to HEX and preview
light_hex <- rgb2hex(rgb_light)
light_hex
#> [1] "#B2CAF6" "#99CC99" "#FF9C80"

# 5. Save the new derived palette for reuse
temp_dir <- file.path(tempdir(), "palettes")
create_palette("three_body_light", "qualitative", light_hex,
               color_dir = temp_dir)
#> v Palette saved: /tmp/.../palettes/qualitative/three_body_light.json

# 6. Verify the new palette is retrievable
"three_body_light" %in% list_palettes(type = "qualitative")$name
#> [1] TRUE

# 7. Clean up
unlink(temp_dir, recursive = TRUE)
```

------------------------------------------------------------------------

## Getting Help

- [`?get_palette`](https://evanbio.github.io/biopalette/reference/get_palette.md),
  [`?list_palettes`](https://evanbio.github.io/biopalette/reference/list_palettes.md)
- [`?preview_palette`](https://evanbio.github.io/biopalette/reference/preview_palette.md),
  [`?palette_gallery`](https://evanbio.github.io/biopalette/reference/palette_gallery.md)
- [`?create_palette`](https://evanbio.github.io/biopalette/reference/create_palette.md),
  [`?remove_palette`](https://evanbio.github.io/biopalette/reference/remove_palette.md),
  [`?compile_palettes`](https://evanbio.github.io/biopalette/reference/compile_palettes.md)
- [`?hex2rgb`](https://evanbio.github.io/biopalette/reference/hex2rgb.md),
  [`?rgb2hex`](https://evanbio.github.io/biopalette/reference/rgb2hex.md)
- [GitHub Issues](https://github.com/evanbio/biopalette/issues)
