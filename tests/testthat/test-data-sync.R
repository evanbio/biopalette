#===============================================================================
# Test: built-in palette data synchronization
# File: test-data-sync.R
# Description: Ensure JSON palette sources and data/palettes.rda stay in sync.
#===============================================================================

test_that("compiled JSON palettes match data/palettes.rda", {
  palettes_dir <- system.file("extdata", "palettes", package = "biopalette")
  rda_path <- system.file("data", "palettes.rda", package = "biopalette")

  skip_if_not(nzchar(palettes_dir) && dir.exists(palettes_dir),
              "Installed palette JSON directory not available")
  skip_if_not(nzchar(rda_path) && file.exists(rda_path),
              "Installed data/palettes.rda not available")

  compiled <- suppressMessages(compile_palettes(palettes_dir))

  e <- new.env(parent = emptyenv())
  load(rda_path, envir = e)
  stored <- get("palettes", envir = e, inherits = FALSE)

  expect_identical(compiled, stored)
})

#===============================================================================
# End: test-data-sync.R
#===============================================================================
