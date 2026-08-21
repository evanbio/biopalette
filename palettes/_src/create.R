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
  name         = "abyss",
  type         = "sequential",
  colors       = c("#0B1F3A", "#3E8EA8", "#E4F1F4"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

source("palettes/_src/preview.R")
