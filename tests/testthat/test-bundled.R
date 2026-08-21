#===============================================================================
# Test: the palette collection that ships with the package
# File: test-bundled.R
# Description: The bundled JSON files are the only copy of the palettes, so they
#              are the thing that has to be well-formed. There is no compiled
#              artefact to drift from any more.
#===============================================================================

bundled <- function() biopalette:::.load_palettes()

test_that("the bundled collection loads cleanly", {
  dir <- system.file("extdata", "palettes", package = "biopalette")
  expect_true(nzchar(dir) && dir.exists(dir))

  # The loader validates every file, so a clean load is the assertion:
  # names, types, directory layout and HEX codes all check out.
  expect_no_error(bundled())
})

test_that("the bundled collection has the expected top-level shape", {
  p <- bundled()

  expect_type(p, "list")
  expect_identical(names(p), c("sequential", "diverging", "qualitative"))
  expect_gt(sum(lengths(p)), 0L)
})

test_that("every bundled palette is a non-empty character vector of HEX codes", {
  p <- bundled()

  for (type in names(p)) {
    for (name in names(p[[type]])) {
      colors <- p[[type]][[name]]

      expect_type(colors, "character")
      expect_gt(length(colors), 0L)
      expect_false(anyNA(colors))
      expect_true(
        all(grepl("^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$", colors)),
        label = paste0(type, "/", name, " HEX codes")
      )
    }
  }
})

test_that("every bundled palette name is snake_case and unique across types", {
  all_names <- unlist(lapply(bundled(), names), use.names = FALSE)

  expect_gt(length(all_names), 0L)
  expect_true(
    all(grepl("^[a-z][a-z0-9_]*$", all_names)),
    label = paste0("names: ", paste(all_names, collapse = ", "))
  )
  # Reason: the name is the lookup key, so a name reused across types would
  # make get_palette() ambiguous. The loader rejects it; this pins the shipped
  # collection itself.
  expect_identical(anyDuplicated(all_names), 0L)
})

test_that("every bundled JSON sits in the directory its type names", {
  dir <- system.file("extdata", "palettes", package = "biopalette")

  for (type in c("sequential", "diverging", "qualitative")) {
    files <- list.files(file.path(dir, type), pattern = "\\.json$", full.names = TRUE)

    for (f in files) {
      parsed <- jsonlite::fromJSON(f)
      expect_identical(parsed$type, type, label = basename(f))
      expect_identical(parsed$name, sub("\\.json$", "", basename(f)))
    }
  }
})

test_that("get_palette() defaults to the bundled collection", {
  p <- bundled()
  first_type <- names(p)[lengths(p) > 0][1]
  first_name <- names(p[[first_type]])[1]

  expect_identical(get_palette(first_name), p[[first_type]][[first_name]])
})

#===============================================================================
# End: test-bundled.R
#===============================================================================
