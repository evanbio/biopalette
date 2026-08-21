# Get a Color Palette

Retrieve a named palette by name and type, returning a vector of HEX
colors. Automatically checks for type mismatch and provides smart
suggestions.

## Usage

``` r
get_palette(name, type = NULL, n = NULL, reverse = FALSE, palettes_dir = NULL)
```

## Arguments

- name:

  Character. Name of the palette (e.g. "qual_vivid").

- type:

  Character. One of "sequential", "diverging", "qualitative". If NULL,
  type is auto-detected.

- n:

  Integer. Number of colors to return. If NULL, returns all colors. See
  *What `n` means* above. Default is NULL.

- reverse:

  Logical. Reverse the palette before `n` is applied, so the two
  arguments stay independent: `reverse` hands back a different palette
  and `n` then selects from it. Default: FALSE.

- palettes_dir:

  Character. Directory holding a palette collection (`sequential/`,
  `diverging/`, `qualitative/` subdirectories of JSON files). If NULL,
  the palettes bundled with the package are used.

## Value

Character vector of HEX color codes.

## What `n` means

`n` is resolved according to what the palette's type says the colors
*are*, because "give me 3 colors" means two different things:

- `qualitative`:

  The colors are unordered categories, so `n` takes the first `n` of
  them. Asking for more than the palette holds is an error — there is no
  way to invent a category that the palette does not contain.

- `sequential`, `diverging`:

  The colors are stops along a ramp, so `n` returns `n` steps spanning
  the *whole* ramp, interpolating as needed. Interpolation takes place
  in Lab colour space, matching the package's ggplot2 gradient scales.
  Any `n` works, above or below the number of stops. Taking the first
  `n` stops instead would silently hand back one end of the ramp — the
  light half of a sequential scale, or one arm of a diverging one.

`n` equal to the number of stops returns the palette untouched. When
`reverse = TRUE` the palette is flipped first, so `n` selects from the
reversed palette.

## Examples

``` r
get_palette("gene_red", type = "qualitative")
#> [1] "#000000" "#B11522"

# Qualitative: the first n categories
get_palette("walter_white2", type = "qualitative", n = 2)
#> [1] "#5AB5BF" "#808C56"

# Sequential: n steps across the whole ramp, not the first n stops
get_palette("mitonuclear_blue")
#> [1] "#EEF4FB" "#DDF1F5" "#B9DBF4" "#95AAD3" "#3A68AE" "#155289"
get_palette("mitonuclear_blue", n = 3)
#> [1] "#EEF4FB" "#A7C2E3" "#155289"

# Ramps can also be stretched beyond the stops they were drawn from
get_palette("walter_white", type = "diverging", n = 9)
#> [1] "#1991A9" "#6DABB7" "#A3C5C4" "#C5D7D4" "#E7E9E4" "#C8CFB5" "#A9B688"
#> [8] "#788759" "#495A2E"

# Flip a ramp end to end
get_palette("mitonuclear_blue", reverse = TRUE)
#> [1] "#155289" "#3A68AE" "#95AAD3" "#B9DBF4" "#DDF1F5" "#EEF4FB"
```
