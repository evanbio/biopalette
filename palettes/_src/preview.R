#===============================================================================
# Generate missing palette previews -> palettes/<name>/preview.png
#
#   source("palettes/_src/preview.R")
#
# Existing previews are left alone. To redo one, delete it and rerun.
#===============================================================================

devtools::load_all(quiet = TRUE)

dir <- "inst/extdata/palettes"
pal <- list_palettes(palettes_dir = dir)

for (i in seq_len(nrow(pal))) {
  out <- file.path("palettes", pal$name[i], "preview.png")
  if (file.exists(out)) next

  dir.create(dirname(out), recursive = TRUE, showWarnings = FALSE)
  png(out, width = 1200, height = 560, res = 200, bg = "white")
  preview_palette(pal$name[i], type = pal$type[i], plot_type = "rect",
                  palettes_dir = dir)
  dev.off()

  cli::cli_alert_success("Preview written: {.file {out}}")
}
