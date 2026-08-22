# biopalette 0.2.2

*Current release: August 2026*

## Maintenance

- Replaced relative README links with stable GitHub URLs for CRAN checks.

# biopalette 0.2.1

*Current release: August 2026*

## Maintenance

- Fixed CRAN DESCRIPTION wording by quoting the software name `'ggplot2'`.
- Compressed the package logo without changing its dimensions.

# biopalette 0.2.0

*Current release: August 2026*

## New features

- Redesigned palette storage and validation around the JSON palette contract.
- Added `palette_info()` for inspecting one palette's metadata and colors.
- Added `scale_color_biopalette()` and `scale_fill_biopalette()` for discrete
  ggplot2 scales.
- Added `scale_color_biopalette_gradient()` and
  `scale_fill_biopalette_gradient()` for sequential and diverging gradients.
- Expanded the test suite across palette storage, color conversion, plotting,
  scales, and startup behavior.

## Palettes

- Added `mitonuclear_blue` and `mitonuclear_orange` — sequential palettes
  inspired by mito-nuclear communication research (TIBS, 2022).
- Added `heat_light` — qualitative, 2 colors, from a bond ampholysis
  illustration (Nature, 2024).
- Added `tam_pastel` — qualitative, 6 colors, from the pan-cancer myeloid
  atlas (Cell, 2021).
- Added `cancer_mosaic` — qualitative, 15 colors, from the pan-cancer myeloid
  atlas (Cell, 2021).
- Added `lactate_steps` — qualitative, 5 colors, from lactate metabolism and
  immunotherapy research (JECCR, 2024).
- Added `bcell_atlas` — qualitative, 7 colors, from a pan-cancer B-cell atlas
  graphical abstract (Cell, 2024).
- Added `bcell_atlas2` — diverging, 5 colors, encoding the IgA-to-IgG shift in
  the same source article.
- Added `bcell_clusters` — qualitative, 20 colors, reconstructed from Figure
  1B of the same pan-cancer B-cell atlas; the published order puts broadly
  useful major-group colors first.
- Added source images, curation records, previews, and showcase figures for
  the new palettes.

## Documentation and integrations

- Reworked the English and Chinese guides around qualitative, sequential, and
  diverging use cases.
- Added a Tessera workflow vignette and linked biopalette to Tessera and
  Palette Lab.
- Expanded README and pkgdown palette tables with recommended use cases and
  figure showcases.
- Updated palette curation templates and source records for the image-inspired
  collection.

## Maintenance

- Aligned package, coverage, and build configuration with the redesigned
  palette storage model.

# biopalette 0.1.0

*Initial release: April 2026*

The initial release established the package API for retrieving, previewing,
organizing, and applying image-inspired color palettes in biomedical
visualization.

## Core functionality

- `get_palette()` — retrieve colors by name, type, and size.
- `list_palettes()` — inspect the bundled palette collection.
- `palette_gallery()` — render a paged visual gallery.
- `preview_palette()` — draw palette swatches in several styles.
- `create_palette()` and `remove_palette()` — manage palette JSON files.
- `hex2rgb()` and `rgb2hex()` — convert HEX and RGB color values.

## Initial palette collection

- `gene_red` — qualitative, 2 colors, inspired by *Better Call Saul*.
- `walter_white`, `walter_white2`, and `walter_white3` — qualitative and
  diverging palettes inspired by *Breaking Bad*.
- `babel` — qualitative, 21 colors, from a pan-cancer myeloid atlas (Cell,
  2021).
- `three_body` — qualitative, 3 colors, from the same myeloid atlas.
