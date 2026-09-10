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
  name         = "lipid_budding",
  type         = "qualitative",
  colors       = c("#6FA6BF", "#D98FB1", "#E99A74", "#7888BD"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

create_palette(
  name         = "lipid_budding_blue",
  type         = "sequential",
  colors       = c("#D2E7EE", "#ADC8D5", "#6A96AA", "#4B7B95", "#1F607E"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

create_palette(
  name         = "lipid_budding_rose",
  type         = "sequential",
  colors       = c("#EED4E1", "#DBAFC2", "#BF7F99", "#A34F72", "#8C2857"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

create_palette(
  name         = "lipid_budding_orange",
  type         = "sequential",
  colors       = c("#F7D8C8", "#E3B3A0", "#C7846E", "#A7553E", "#8E321D"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

create_palette(
  name         = "lipid_budding_indigo",
  type         = "sequential",
  colors       = c("#D5DBEE", "#B0B6D4", "#8087B2", "#505B90", "#283C78"),
  palettes_dir = "inst/extdata/palettes",
  overwrite    = FALSE
)

source("palettes/_src/preview.R")
