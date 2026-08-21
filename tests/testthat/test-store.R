#===============================================================================
# Test: palette collection loading, caching and validation
# File: test-store.R
# Description: Unit tests for .load_palettes() and the public palettes_dir
#              argument that exposes it.
#===============================================================================

# Helper: build a palette collection directory from a spec.
#   spec: named list of type -> named list of palette -> colors
make_collection <- function(spec, root = tempfile("pal_")) {
  for (type in names(spec)) {
    dir.create(file.path(root, type), recursive = TRUE, showWarnings = FALSE)
    for (nm in names(spec[[type]])) {
      jsonlite::write_json(
        list(name = nm, type = type, colors = spec[[type]][[nm]]),
        path = file.path(root, type, paste0(nm, ".json")),
        pretty = TRUE, auto_unbox = TRUE
      )
    }
  }
  root
}

# Helper: write a raw JSON body into a collection, bypassing validation.
write_raw <- function(root, type, stem, body) {
  dir.create(file.path(root, type), recursive = TRUE, showWarnings = FALSE)
  writeLines(body, file.path(root, type, paste0(stem, ".json")))
  root
}

#==============================================================================
# .load_palettes() — explicit directory
#==============================================================================

test_that(".load_palettes() reads a collection from an explicit directory", {
  root <- make_collection(list(
    sequential  = list(seq_one = c("#deebf7", "#3182bd")),
    qualitative = list(qual_one = c("#E64B35", "#4DBBD5"))
  ))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  p <- biopalette:::.load_palettes(root)

  expect_identical(names(p), c("sequential", "diverging", "qualitative"))
  expect_identical(p$sequential$seq_one, c("#deebf7", "#3182bd"))
  expect_identical(p$qualitative$qual_one, c("#E64B35", "#4DBBD5"))
  expect_length(p$diverging, 0L)
})

test_that(".load_palettes() errors when the directory does not exist", {
  missing <- file.path(tempdir(), "definitely_not_here")
  expect_false(dir.exists(missing))

  expect_error(biopalette:::.load_palettes(missing), "does not exist")
})

test_that(".load_palettes() errors when the directory holds no palettes", {
  root <- tempfile("empty_")
  dir.create(file.path(root, "sequential"), recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_error(biopalette:::.load_palettes(root), "No palette JSON files")
})

test_that(".load_palettes() rejects a non-string directory", {
  expect_error(biopalette:::.load_palettes(123), "single non-empty string")
  expect_error(biopalette:::.load_palettes(c("a", "b")), "single non-empty string")
  expect_error(biopalette:::.load_palettes(list()), "single non-empty string")
})

#==============================================================================
# .load_palettes() — bundled collection
#==============================================================================

test_that(".load_palettes() falls back to the bundled collection when NULL", {
  expect_identical(
    biopalette:::.load_palettes(NULL),
    biopalette:::.load_palettes()
  )
  expect_gt(sum(lengths(biopalette:::.load_palettes())), 0L)
})

#==============================================================================
# Caching
#==============================================================================

test_that("a repeated read of the same directory is served from cache", {
  root <- make_collection(list(qualitative = list(a = "#111111")))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  first  <- biopalette:::.load_palettes(root)
  key    <- biopalette:::.palette_cache_key(root)
  cached <- get(key, envir = biopalette:::.palette_cache, inherits = FALSE)

  expect_identical(cached$palettes, first)
  expect_identical(biopalette:::.load_palettes(root), first)
})

test_that("create_palette() is visible to the very next read", {
  # Reason: this is the whole point of the cache being invalidated on write —
  # a user who just created a palette must be able to use it immediately.
  root <- make_collection(list(qualitative = list(a = "#111111")))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_length(biopalette:::.load_palettes(root)$qualitative, 1L)

  suppressMessages(create_palette("b", "qualitative", "#222222", palettes_dir = root))

  expect_length(biopalette:::.load_palettes(root)$qualitative, 2L)
  expect_identical(get_palette("b", palettes_dir = root), "#222222")
})

test_that("remove_palette() is visible to the very next read", {
  root <- make_collection(list(qualitative = list(a = "#111111", b = "#222222")))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_length(biopalette:::.load_palettes(root)$qualitative, 2L)

  suppressMessages(remove_palette("b", palettes_dir = root))

  expect_length(biopalette:::.load_palettes(root)$qualitative, 1L)
  expect_error(get_palette("b", palettes_dir = root), "not found in any type")
})

test_that("an edit made outside the package still invalidates the cache", {
  root <- make_collection(list(qualitative = list(a = "#111111")))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_identical(get_palette("a", palettes_dir = root), "#111111")

  # Written directly, so no invalidation hook runs — only the stamp can catch it.
  f <- file.path(root, "qualitative", "a.json")
  jsonlite::write_json(list(name = "a", type = "qualitative", colors = c("#111111", "#333333")),
                       path = f, pretty = TRUE, auto_unbox = TRUE)

  expect_identical(get_palette("a", palettes_dir = root), c("#111111", "#333333"))
})

#==============================================================================
# Validation — every bad file is reported, and one bad file is fatal
#==============================================================================

test_that("a malformed JSON file makes the whole collection unusable", {
  # Reason: skipping the bad file would surface later as a puzzling
  # "not found" for a palette whose file is plainly sitting there.
  root <- make_collection(list(qualitative = list(good = "#111111")))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  write_raw(root, "qualitative", "broken", "{not valid json")

  expect_error(biopalette:::.load_palettes(root), "could not be loaded")
  expect_error(biopalette:::.load_palettes(root), "broken\\.json")
  expect_error(get_palette("good", palettes_dir = root), "could not be loaded")
})

test_that("all problems are reported together, not one per run", {
  root <- tempfile("bad_")
  write_raw(root, "qualitative", "no_colors", '{"name": "no_colors", "type": "qualitative"}')
  write_raw(root, "qualitative", "bad_hex",
            '{"name": "bad_hex", "type": "qualitative", "colors": ["nope"]}')
  write_raw(root, "qualitative", "wrong_type",
            '{"name": "wrong_type", "type": "sequential", "colors": ["#111111"]}')
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  err <- tryCatch(biopalette:::.load_palettes(root), error = function(e) e)
  msg <- paste(conditionMessage(err), collapse = " ")

  expect_match(msg, "3 palette files")
  expect_match(msg, "missing field")
  expect_match(msg, "invalid HEX")
  expect_match(msg, "does not match its directory")
})

test_that("a name that disagrees with the file stem is rejected", {
  root <- tempfile("stem_")
  write_raw(root, "qualitative", "on_disk",
            '{"name": "in_json", "type": "qualitative", "colors": ["#111111"]}')
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_error(biopalette:::.load_palettes(root), "does not match the file stem")
})

test_that("a name that is not snake_case is rejected", {
  root <- tempfile("case_")
  write_raw(root, "qualitative", "BadName",
            '{"name": "BadName", "type": "qualitative", "colors": ["#111111"]}')
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_error(biopalette:::.load_palettes(root), "not snake_case")
})

test_that("a name or type that is not a scalar is rejected", {
  root <- tempfile("scalar_")
  write_raw(root, "qualitative", "arr",
            '{"name": ["a", "b"], "type": "qualitative", "colors": ["#111111"]}')
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_error(biopalette:::.load_palettes(root), "must be a single non-empty string")
})

test_that("a duplicate palette name across types is an error", {
  # Reason: the name is the lookup key, so a duplicate makes get_palette()
  # ambiguous. Last-one-wins would silently pick for the user.
  root <- tempfile("dup_")
  write_raw(root, "qualitative", "twin",
            '{"name": "twin", "type": "qualitative", "colors": ["#111111"]}')
  write_raw(root, "sequential", "twin",
            '{"name": "twin", "type": "sequential", "colors": ["#222222"]}')
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_error(biopalette:::.load_palettes(root), "duplicate palette name")
})

#==============================================================================
# Public palettes_dir argument
#==============================================================================

test_that("get_palette() reads from an explicit palettes_dir", {
  root <- make_collection(list(qualitative = list(
    only_here = c("#111111", "#222222", "#333333"))))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_identical(get_palette("only_here", palettes_dir = root),
                   c("#111111", "#222222", "#333333"))
  expect_identical(get_palette("only_here", n = 2, palettes_dir = root),
                   c("#111111", "#222222"))
  # The user's collection shadows the bundled one entirely.
  expect_error(get_palette("gene_red", palettes_dir = root), "not found in any type")
})

test_that("list_palettes() reads from an explicit palettes_dir", {
  root <- make_collection(list(
    sequential  = list(seq_one = c("#deebf7", "#3182bd")),
    qualitative = list(qual_one = c("#E64B35", "#4DBBD5", "#00A087"))
  ))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  result <- list_palettes(palettes_dir = root)
  expect_equal(nrow(result), 2L)
  expect_setequal(result$name, c("seq_one", "qual_one"))
  expect_equal(result$n_color[result$name == "qual_one"], 3L)
})

test_that(".resolve_palette() returns one stable palette record", {
  root <- make_collection(list(
    sequential = list(only_here = c("#EEEEEE", "#111111"))
  ))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  result <- biopalette:::.resolve_palette("only_here", palettes_dir = root)

  expect_named(result, c("name", "type", "colors"))
  expect_identical(result$name, "only_here")
  expect_identical(result$type, "sequential")
  expect_identical(result$colors, c("#EEEEEE", "#111111"))
})

test_that(".resolve_palette() owns lookup validation and type errors", {
  root <- make_collection(list(qualitative = list(only_here = "#111111")))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  expect_error(
    biopalette:::.resolve_palette("only_here", type = "diverging", palettes_dir = root),
    "does not belong to type.*diverging"
  )
  expect_error(
    biopalette:::.resolve_palette("missing", palettes_dir = root),
    "not found in any type"
  )
  expect_error(
    biopalette:::.resolve_palette(123, palettes_dir = root),
    "single non-empty string"
  )
})

test_that("palette_gallery() reads from an explicit palettes_dir", {
  root <- make_collection(list(qualitative = list(a = "#111111", b = "#222222")))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  result <- palette_gallery(verbose = FALSE, palettes_dir = root)
  expect_named(result, "qualitative_page1")
  expect_s3_class(result[["qualitative_page1"]], "gg")
})

test_that("palette_gallery() skips types that hold no palettes", {
  root <- make_collection(list(qualitative = list(a = "#111111")))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  result <- palette_gallery(verbose = FALSE, palettes_dir = root)
  expect_length(result, 1L)
  expect_false(any(grepl("^sequential", names(result))))
  expect_false(any(grepl("^diverging", names(result))))
})

test_that("palette_gallery() reports progress when verbose = TRUE", {
  root <- make_collection(list(qualitative = list(a = "#111111")))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  msgs <- capture_messages(palette_gallery(verbose = TRUE, palettes_dir = root))

  expect_length(msgs, 2L)
  expect_match(msgs[1], "1 palettes")
  expect_match(msgs[2], "qualitative_page1")
})

test_that("preview_palette() reads from an explicit palettes_dir", {
  root <- make_collection(list(qualitative = list(only_here = c("#111111", "#222222"))))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(grDevices::dev.off(), add = TRUE)

  expect_no_error(preview_palette("only_here", palettes_dir = root))
})

#==============================================================================
# Nothing is resolved against the working directory
#==============================================================================

test_that("a palette collection in the working directory is never picked up", {
  # Reason: regression guard. The loader used to fall back to a relative
  # "data/palettes.rda", so biopalette::get_palette() silently returned
  # whatever happened to sit under the user's working directory.
  skip_on_cran()

  rscript <- file.path(R.home("bin"),
                       if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript")
  skip_if_not(file.exists(rscript), "Rscript not found")

  decoy <- file.path(tempdir(), "biopalette_cwd_decoy")
  make_collection(list(qualitative = list(gene_red = c("#DEADBE", "#EFDEAD"))),
                  root = file.path(decoy, "extdata", "palettes"))
  make_collection(list(qualitative = list(gene_red = c("#DEADBE", "#EFDEAD"))),
                  root = file.path(decoy, "palettes"))
  on.exit(unlink(decoy, recursive = TRUE), add = TRUE)

  script <- tempfile(fileext = ".R")
  answer <- tempfile(fileext = ".txt")
  on.exit(unlink(c(script, answer)), add = TRUE)

  # The child sets its own .libPaths() from argv rather than inheriting R_LIBS:
  # system2(env = ) is a no-op on Windows, and Sys.setenv() here would mutate
  # the environment of whoever is running the tests.
  writeLines(c(
    'args <- commandArgs(TRUE)',
    '.libPaths(strsplit(args[1], .Platform$path.sep, fixed = TRUE)[[1]])',
    'setwd(args[2])',
    'writeLines(paste(biopalette::get_palette("gene_red"), collapse = " "), args[3])'
  ), script)

  status <- system2(
    rscript,
    args = c("--vanilla", shQuote(script),
             shQuote(paste(.libPaths(), collapse = .Platform$path.sep)),
             shQuote(decoy), shQuote(answer)),
    stdout = FALSE, stderr = FALSE
  )

  expect_identical(status, 0L)
  expect_true(file.exists(answer))
  expect_identical(readLines(answer), paste(get_palette("gene_red"), collapse = " "))
})



#==============================================================================
# Cache invalidation reaches the bundled entry
#==============================================================================

test_that("writing into the bundled directory drops the bundled cache entry", {
  # Reason: the bundled collection is cached under a fixed key and is not
  # stamp-checked. A write aimed at that directory - what the curation
  # workflow does under devtools::load_all() - must still be seen.
  bundled <- biopalette:::.bundled_palettes_dir()
  skip_if_not(nzchar(bundled) && dir.exists(bundled), "bundled collection unavailable")

  before <- biopalette:::.load_palettes()
  expect_true(exists("..bundled", envir = biopalette:::.palette_cache, inherits = FALSE))

  biopalette:::.invalidate_palette_cache(bundled)
  expect_false(exists("..bundled", envir = biopalette:::.palette_cache, inherits = FALSE))

  # And it still reloads to the same thing.
  expect_identical(biopalette:::.load_palettes(), before)
})

#===============================================================================
# End: test-store.R
#===============================================================================
