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
  name         = "cytokine_sensors",
  type         = "qualitative",
  colors       = c("#4778A8", "#F17B43", "#4F8750", "#D85668",
                   "#754B82", "#4FA69A", "#626262"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

source("palettes/_src/preview.R")
