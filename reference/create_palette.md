# Create and Save a Custom Color Palette

Save a named color palette as a JSON file in a collection directory. The
palette is usable immediately: point any reading function at the same
`palettes_dir`. The JSON is written to a same-directory temporary file,
validated, and then committed; a failed overwrite leaves the previous
palette intact.

## Usage

``` r
create_palette(
  name,
  type = c("sequential", "diverging", "qualitative"),
  colors,
  palettes_dir,
  overwrite = FALSE
)
```

## Arguments

- name:

  Character. Palette name (e.g., "blues").

- type:

  Character. One of "sequential", "diverging", or "qualitative".

- colors:

  Character vector of HEX color values (e.g., "#E64B35" or "#E64B35B2").

- palettes_dir:

  Character. Directory to write the palette into. Required: there is
  deliberately no default, so a palette can never be written into the
  collection that ships with the package.

- overwrite:

  Logical. If TRUE, overwrite existing palette file. Default: FALSE.

## Value

Invisibly returns a list with `path` and `info`.

## Examples

``` r
temp_dir <- file.path(tempdir(), "palettes")
create_palette("blues", "sequential", c("#deebf7", "#9ecae1", "#3182bd"),
  palettes_dir = temp_dir)
#> ✔ Palette saved: /tmp/Rtmp4Yj9M2/palettes/sequential/blues.json
create_palette("qual_vivid", "qualitative", c("#E64B35", "#4DBBD5", "#00A087"),
  palettes_dir = temp_dir)
#> ✔ Palette saved: /tmp/Rtmp4Yj9M2/palettes/qualitative/qual_vivid.json

# Overwrite an existing palette explicitly
create_palette("blues", "sequential", c("#c6dbef", "#6baed6", "#2171b5"),
  palettes_dir = temp_dir, overwrite = TRUE)
#> ℹ Overwriting existing palette: "blues"
#> ✔ Palette saved: /tmp/Rtmp4Yj9M2/palettes/sequential/blues.json

unlink(temp_dir, recursive = TRUE)
```
