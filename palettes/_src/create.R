#===============================================================================
# Add a palette. Edit the call below, then source this file.
#
#   source("palettes/_src/create.R")
#
# Writes the JSON, recompiles data/palettes.rda, renders the missing preview.
# Then write palettes/<name>/README.md from palettes/_TEMPLATE.md.
#===============================================================================

devtools::load_all(quiet = TRUE)

create_palette(
  name      = "abyss",
  type      = "sequential",
  colors    = c("#0B1F3A", "#3E8EA8", "#E4F1F4"),
  color_dir = "inst/extdata/palettes",
  overwrite = FALSE
)

source("data-raw/palettes.R")
source("palettes/_src/preview.R")
