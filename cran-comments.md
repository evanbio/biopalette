## CRAN Comments for biopalette 0.2.0

# biopalette 0.2.0

This submission packages the 0.2.0 release. Version 0.1.0 is retained as the
historical baseline in NEWS.md; this release redesigns palette storage and
adds ggplot2 scales, expanded tests, Tessera/Palette Lab documentation, and
three B-cell atlas palettes.

## Test environments

* local Windows 11, R 4.5.1
* GitHub Actions across the package-supported R versions

## R CMD check results

0 errors | 0 warnings | 0 notes

## Changes in this version

- Added `palette_info()` and discrete/continuous ggplot2 scale helpers.
- Added `bcell_atlas`, `bcell_atlas2`, and `bcell_clusters`.
- Updated package documentation, curation records, and visual showcases.

# Historical 0.1.0 release

The April 2026 initial release established the core palette retrieval, preview,
storage, color-conversion, and palette-management functions together with the
`gene_red`, `walter_white`, `walter_white2`, `walter_white3`, `babel`, and
`three_body` palettes.
