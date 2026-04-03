library(evanverse)

# =============================================================================
# 001 — gene_red
# =============================================================================

id          <- "gene_red"
index       <- "001"
dir_name    <- paste0(index, "_", id)
color_dir   <- "inst/extdata/palettes"
preview_dir <- file.path("palettes", dir_name)
colors      <- c("#000000", "#B11522")
dpi         <- 200

# 1. Create -------------------------------------------------------------------
create_palette(
  name      = id,
  type      = "qualitative",
  colors    = colors,
  color_dir = color_dir
)

# 2. Compile ------------------------------------------------------------------
palettes <- compile_palettes(color_dir)
usethis::use_data(palettes, overwrite = TRUE)

# 3. Preview ------------------------------------------------------------------
dir.create(preview_dir, recursive = TRUE, showWarnings = FALSE)
png(file.path(preview_dir, paste0(id, "_preview.png")),
    width = round(6 * dpi), height = round(2.8 * dpi),
    res = dpi, bg = "white")
preview_palette(id, type = "qualitative", plot_type = "rect",
                palettes_path = "data/palettes.rda")
dev.off()
