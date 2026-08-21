---
# Palette name. Use snake_case: ^[a-z][a-z0-9_]*$.
# Keep this value identical in the folder name and in
# inst/extdata/palettes/<type>/<name>.json. This is the name used by
# get_palette("<name>").
name: palette_name

# Collection index. Use an integer reflecting the order in which palettes were
# added to the collection. This is metadata only and is not part of any path.
index: 0

# Structural type: what kind of data mapping the palette supports.
# qualitative | sequential | diverging
# This must match the JSON type and determines its subdirectory.
type: qualitative

# Source category: where the reference image comes from. This is independent
# of type.
# paper | screen
source: paper

# Source image stem in palettes/_source/, without a path or extension. When
# several palettes use one image, use the stem of the first palette that uses
# it. For example, walter_white, walter_white2, and walter_white3 all use
# walter_white here. The shared image already records their common source.
image: palette_name

# Date added to the collection, in YYYY-MM-DD format.
date: 2026-01-01
---

# palette_name

## Source

![source](../_source/palette_name.jpg)

Explain why this image is the reference: what it is, where it comes from, and
what visual structure it contributes to the palette.

Describe the sampling or reconstruction decisions that affect interpretation.
If the colors were translated—for example, by adding a transition between
extreme black and white—document that decision here. Do not add an empty
section when no such decision was made.

## Palette

![preview](preview.png)

<!-- Copy HEX values from the JSON; order is meaningful.
     For screen sources, use color names (for example, Sky teal). For paper
     sources, use the source figure's group labels (for example, Macro_SPP1),
     and state that those labels document the source rather than prescribing
     a mapping for users. -->

| # | HEX | Color |
|---|---|---|
| 1 | `#000000` | Color name or source group label |

## Use cases

<!-- Name concrete plot types or comparison settings. Avoid vague statements
     such as "suitable for data visualization." Include limitations when color
     alone is insufficient, such as close hues, light swatches, or accessibility
     concerns. -->

- ...
