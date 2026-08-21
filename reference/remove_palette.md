# Remove a Saved Palette JSON

Remove a palette JSON file by name, searching across types if needed.

## Usage

``` r
remove_palette(name, type = NULL, palettes_dir)
```

## Arguments

- name:

  Character. Palette name (without '.json' suffix).

- type:

  Character. One of "sequential", "diverging", "qualitative". If NULL,
  searches all types.

- palettes_dir:

  Character. Directory holding the palette collection. Required: there
  is deliberately no default, so the collection that ships with the
  package can never be removed from.

## Value

Invisibly TRUE if removed successfully, FALSE otherwise.

## Examples

``` r
temp_dir <- tempfile("biopalette-palettes-")
create_palette(
  "example_palette",
  "qualitative",
  c("#E64B35", "#4DBBD5", "#00A087"),
  palettes_dir = temp_dir
)
#> ✔ Palette saved: /tmp/RtmpLZxCtT/biopalette-palettes-195020bea378/qualitative/example_palette.json

remove_palette("example_palette", palettes_dir = temp_dir)
#> ✔ Removed "example_palette" from qualitative
unlink(temp_dir, recursive = TRUE)
```
