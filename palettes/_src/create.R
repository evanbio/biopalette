#===============================================================================
# Add a palette. Edit the call below, then source this file.
#
#   source("palettes/_src/create.R")
#
# Writes the JSON and renders the missing preview. The JSON *is* the palette;
# there is no compile step any more.
# Then write palettes/<name>/README.md from palettes/_TEMPLATE.md.
#===============================================================================

devtools::load_all(quiet = TRUE)

create_palette(
  name         = "ppi_obligate",
  type         = "qualitative",
  colors       = c("#626EAE", "#9672AC", "#87BE42", "#DDB657"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

create_palette(
  name         = "ppi_nonspecific",
  type         = "qualitative",
  colors       = c("#9B6DA9", "#84B83F"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

create_palette(
  name         = "ppi_transient",
  type         = "diverging",
  colors       = c("#DE5360", "#E78F96", "#E5E4E1", "#A9BED4", "#6D94BC"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

source("palettes/_src/preview.R")
