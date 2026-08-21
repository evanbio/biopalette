#===============================================================================
# Test: preview and gallery rendering
# File: test-plot.R
#===============================================================================

#==============================================================================
# preview_palette()
#==============================================================================

test_that("preview_palette() returns NULL invisibly", {
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(grDevices::dev.off(), add = TRUE)

  result <- preview_palette("walter_white", type = "diverging", plot_type = "bar")
  expect_null(result)
})

test_that("preview_palette() works with all plot_type options", {
  for (pt in c("bar", "pie", "point", "rect", "circle")) {
    pdf(file = tempfile(fileext = ".pdf"))
    expect_no_error(
      preview_palette("gene_red", type = "qualitative", plot_type = pt)
    )
    grDevices::dev.off()
  }
})

test_that("preview_palette() respects n argument", {
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(grDevices::dev.off(), add = TRUE)

  expect_no_error(
    preview_palette("gene_red", type = "qualitative", n = 2, plot_type = "bar")
  )
})

test_that("preview_palette() accepts custom title", {
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(grDevices::dev.off(), add = TRUE)

  expect_no_error(
    preview_palette("walter_white", type = "diverging", title = "My Custom Title")
  )
})

test_that("preview_palette() errors on invalid palette name", {
  expect_error(
    preview_palette("does_not_exist"),
    "not found in any type"
  )
})

test_that("preview_palette() returns invisible NULL for every plot_type", {
  # Reason: the return shape must not depend on plot_type. "rect" draws via
  # ggplot2 and the rest via base graphics, but callers see one contract.
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(grDevices::dev.off(), add = TRUE)

  for (pt in c("bar", "pie", "point", "rect", "circle")) {
    res <- withVisible(preview_palette("gene_red", plot_type = pt))
    expect_null(res$value, label = pt)
    expect_false(res$visible, label = pt)
  }
})

test_that("preview_palette() leaves graphics parameters as it found them", {
  # Reason: the base-graphics branches set par(mai). Anything the package
  # touches has to be handed back untouched, or a palette preview would
  # silently reshape the user's next plot.
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(grDevices::dev.off(), add = TRUE)

  for (pt in c("bar", "pie", "point", "rect", "circle")) {
    before <- graphics::par("mai")
    preview_palette("gene_red", plot_type = pt)
    expect_identical(graphics::par("mai"), before, label = pt)
  }
})

test_that(".preview_plot_rect() returns a ggplot object rather than drawing", {
  p <- biopalette:::.preview_plot_rect(c("#111111", "#222222"), "demo")
  expect_s3_class(p, "gg")
})

#==============================================================================
# palette_gallery()
#==============================================================================

test_that("palette_gallery() returns named list of ggplot objects", {
  skip_if_not_installed("ggplot2")

  result <- palette_gallery(type = "qualitative", verbose = FALSE)
  expect_type(result, "list")
  expect_true(length(result) >= 1L)
  expect_true(all(sapply(result, inherits, "gg")))
  expect_true(all(grepl("^qualitative_page", names(result))))
})

test_that("palette_gallery() paginates correctly", {
  skip_if_not_installed("ggplot2")

  result <- palette_gallery(type = "qualitative", max_palettes = 1, verbose = FALSE)
  expect_true(length(result) > 1L)
})

test_that("palette_gallery() errors on invalid type argument", {
  # match.arg rejects strings not in the allowed set
  expect_error(
    palette_gallery(type = "rainbow"),
    "should be one of"
  )
})

test_that("palette_gallery() validates max_palettes and max_row", {
  expect_error(palette_gallery(max_palettes = 0),  "single positive integer")
  expect_error(palette_gallery(max_row = -1),       "single positive integer")
  expect_error(palette_gallery(verbose = "yes"),    "TRUE or FALSE")
})

#==============================================================================
# .tile_x()
#==============================================================================

test_that(".tile_x() centres the tiles inside the slot grid", {
  # 2 tiles in a 12-slot grid: equal margin on both sides, so the midpoint
  # of the tiles has to land on the midpoint of the grid.
  xs <- biopalette:::.tile_x(2, 12)

  expect_length(xs, 2L)
  expect_identical(xs, c(5.5, 6.5))
  expect_identical(mean(xs), 6)
})

test_that(".tile_x() fills the grid exactly when n_colors == n_slots", {
  xs <- biopalette:::.tile_x(12, 12)

  expect_length(xs, 12L)
  expect_identical(xs[1], 0.5)
  expect_identical(xs[12], 11.5)
})

test_that(".tile_x() widens the grid when it is smaller than the palette", {
  # Reason: n_slots is a minimum width, not a cap — a 15-colour palette must
  # not be squeezed into 12 slots or the tiles would overlap.
  xs <- biopalette:::.tile_x(15, 12)

  expect_length(xs, 15L)
  expect_identical(xs[1], 0.5)
  expect_identical(xs[15], 14.5)
  expect_true(all(diff(xs) == 1))
})

#==============================================================================
# .gallery_page_data()
#==============================================================================

test_that(".gallery_page_data() returns aligned plot and label data", {
  pal <- list(a = c("#111111", "#222222"), b = c("#333333"))
  rows <- data.frame(name = c("a", "b"), n = c(2L, 1L), stringsAsFactors = FALSE)

  page <- biopalette:::.gallery_page_data(rows, pal, "qualitative", max_row = 12)

  expect_named(page, c("plot_data", "label_data"))
  expect_equal(nrow(page$plot_data), 3L)      # one row per colour
  expect_equal(nrow(page$label_data), 2L)     # one label per palette
  expect_identical(unique(page$plot_data$type), "qualitative")
  expect_setequal(page$label_data$name, c("a", "b"))
})

test_that(".gallery_page_data() wraps a palette wider than max_row", {
  # Reason: a 21-colour palette cannot sit on one line; it has to break into
  # ceiling(21 / 12) = 2 rows, each carrying its own label entry.
  pal <- list(wide = sprintf("#%06X", seq_len(21)))
  rows <- data.frame(name = "wide", n = 21L, stringsAsFactors = FALSE)

  page <- biopalette:::.gallery_page_data(rows, pal, "qualitative", max_row = 12)

  expect_equal(nrow(page$plot_data), 21L)
  expect_equal(nrow(page$label_data), 2L)
  expect_equal(length(unique(page$plot_data$y)), 2L)
})

#===============================================================================
# End: test-plot.R
#===============================================================================
