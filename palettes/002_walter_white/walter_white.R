library(evanverse)

# =============================================================================
# 002 — walter_white
# =============================================================================

id          <- "walter_white"
index       <- "002"
dir_name    <- paste0(index, "_", id)
color_dir   <- "inst/extdata/palettes"
preview_dir <- file.path("palettes", dir_name)
colors      <- c("#1991A9", "#A3C5C4", "#E7E9E4", "#A9B688", "#495A2E")
dpi         <- 200

# 1. Create -------------------------------------------------------------------
create_palette(
  name      = id,
  type      = "diverging",
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
preview_palette(id, type = "diverging", plot_type = "rect",
                palettes_path = "data/palettes.rda")
dev.off()


# =============================================================================
# 002 — walter_white2
# =============================================================================

id     <- "walter_white2"
colors <- c("#5AB5BF", "#808C56", "#D1BE9E", "#F29E6D", "#BF8888")

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
png(file.path(preview_dir, paste0(id, "_preview.png")),
    width = round(6 * dpi), height = round(2.8 * dpi),
    res = dpi, bg = "white")
preview_palette(id, type = "qualitative", plot_type = "rect",
                palettes_path = "data/palettes.rda")
dev.off()


# =============================================================================
# 002 — walter_white3
# =============================================================================

id     <- "walter_white3"
colors <- c("#B15F63", "#C68687", "#E0D0C3", "#B2BF93", "#6F824B")

# 1. Create -------------------------------------------------------------------
create_palette(
  name      = id,
  type      = "diverging",
  colors    = colors,
  color_dir = color_dir
)

# 2. Compile ------------------------------------------------------------------
palettes <- compile_palettes(color_dir)
usethis::use_data(palettes, overwrite = TRUE)

# 3. Preview ------------------------------------------------------------------
png(file.path(preview_dir, paste0(id, "_preview.png")),
    width = round(6 * dpi), height = round(2.8 * dpi),
    res = dpi, bg = "white")
preview_palette(id, type = "diverging", plot_type = "rect",
                palettes_path = "data/palettes.rda")
dev.off()
