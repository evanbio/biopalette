devtools::load_all()

# =============================================================================
# 003 — babel
# =============================================================================

id          <- "babel"
index       <- "003"
dir_name    <- paste0(index, "_", id)
color_dir   <- "inst/extdata/palettes"
preview_dir <- file.path("palettes", dir_name)
colors      <- c(
  # Figure colors (positions 1–13, legend order from source figure)
  "#1688A7", "#7673AE", "#B3DE69", "#D195F6", "#7E285E",
  "#8197FF", "#0911E9", "#FF9E81", "#EF5276", "#EB2C1D",
  "#FD7915", "#FEC718", "#E43EC1",
  # Extended colors (positions 14–22, remaining from source)
  "#1FDBFE", "#B1E7E7", "#B03C0B", "#F39800", "#E64B35",
  "#A443B2", "#FFE4B5", "#FFF56A"
)
dpi         <- 200

# 1. Create -------------------------------------------------------------------
create_palette(
  name      = id,
  type      = "qualitative",
  colors    = colors,
  color_dir = color_dir,
  overwrite = TRUE
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
