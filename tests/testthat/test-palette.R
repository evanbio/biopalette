#===============================================================================
# Test: palette.R public functions
# File: test-palette.R
#===============================================================================

#==============================================================================
# get_palette()
#==============================================================================

test_that("get_palette() returns full color vector with explicit type", {
  result <- get_palette("gene_red", type = "qualitative")
  expect_type(result, "character")
  expect_true(length(result) >= 1L)
  expect_true(all(grepl("^#[0-9A-Fa-f]{6,8}$", result)))
})

test_that("get_palette() returns correct subset with n", {
  result <- get_palette("gene_red", type = "qualitative", n = 2)
  expect_length(result, 2L)
  expect_type(result, "character")
})

test_that("get_palette() auto-detects type when type = NULL", {
  result <- get_palette("walter_white")
  expect_type(result, "character")
  expect_true(length(result) >= 1L)
})

test_that("get_palette() errors when name is found under a different type", {
  # walter_white is diverging, not qualitative
  expect_error(
    get_palette("walter_white", type = "qualitative"),
    "does not belong to type.*qualitative"
  )
})

test_that("get_palette() errors when name is not found anywhere", {
  expect_error(
    get_palette("nonexistent_palette_xyz"),
    "not found in any type"
  )
})

#==============================================================================
# get_palette() — what `n` means, per type
#==============================================================================

test_that("n takes the first n colors of a qualitative palette", {
  full <- get_palette("walter_white2", type = "qualitative")

  expect_identical(get_palette("walter_white2", n = 2), full[1:2])
  expect_identical(get_palette("walter_white2", n = 1), full[1])
})

test_that("n cannot exceed the size of a qualitative palette", {
  # Reason: the colors are unordered categories. Interpolating between them
  # would invent a category the palette does not contain.
  expect_error(
    get_palette("walter_white2", type = "qualitative", n = 9999),
    "only has .* colors"
  )
  expect_error(
    get_palette("walter_white2", type = "qualitative", n = 9999),
    "cannot be interpolated"
  )
})

test_that("n spans the whole ramp of a sequential palette", {
  full <- get_palette("mitonuclear_blue")
  expect_length(full, 6L)

  three <- get_palette("mitonuclear_blue", n = 3)

  expect_length(three, 3L)
  # The ends of the ramp are kept; the old truncation returned full[1:3],
  # i.e. only the light half.
  expect_identical(three[1], full[1])
  expect_identical(three[3], full[6])
  expect_false(identical(three, full[1:3]))
})

test_that("n can stretch a ramp beyond the stops it was drawn from", {
  full <- get_palette("walter_white", type = "diverging")
  expect_length(full, 5L)

  nine <- get_palette("walter_white", type = "diverging", n = 9)

  expect_length(nine, 9L)
  expect_identical(nine[1], full[1])
  expect_identical(nine[9], full[5])
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", nine)))
})

test_that("an odd n keeps the midpoint of a diverging palette", {
  full <- get_palette("walter_white", type = "diverging")

  expect_identical(get_palette("walter_white", n = 3)[2], full[3])
})

test_that("n equal to the palette size returns it untouched", {
  # Reason: colorRampPalette() would rebuild the vector and upper-case the hex
  # codes on the way, so this has to short-circuit to stay byte-identical.
  for (nm in c("mitonuclear_blue", "walter_white", "walter_white2")) {
    full <- get_palette(nm)
    expect_identical(get_palette(nm, n = length(full)), full)
  }
})

test_that(".ramp_colors() preserves an alpha channel", {
  opaque <- biopalette:::.ramp_colors(c("#FF0000", "#0000FF"), 3)
  expect_true(all(nchar(opaque) == 7L))

  translucent <- biopalette:::.ramp_colors(c("#FF000080", "#0000FF80"), 3)
  expect_true(all(nchar(translucent) == 9L))
  expect_match(translucent[2], "80$")
})


#==============================================================================
# palette_info()
#==============================================================================

test_that("palette_info() returns one row with the list_palettes() schema", {
  result <- palette_info("walter_white")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 1L)
  expect_named(result, c("name", "type", "n_color", "colors"))
  expect_identical(result$name, "walter_white")
  expect_identical(result$type, "diverging")
  expect_identical(result$n_color, length(get_palette("walter_white")))
  expect_identical(result$colors[[1]], get_palette("walter_white"))
})

test_that("palette_info() matches the corresponding list_palettes() row", {
  one <- palette_info("babel")
  all <- list_palettes()
  row <- all[all$name == "babel", , drop = FALSE]
  row.names(row) <- NULL

  expect_identical(one, row)
})

test_that("palette_info() shares resolver validation and custom collections", {
  root <- file.path(tempdir(), paste0("palette_info_", Sys.getpid()))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  suppressMessages(create_palette(
    "custom_info", "sequential", c("#EEEEEE", "#111111"),
    palettes_dir = root
  ))

  result <- palette_info("custom_info", palettes_dir = root)
  expect_identical(result$type, "sequential")
  expect_identical(result$n_color, 2L)
  expect_error(
    palette_info("custom_info", type = "qualitative", palettes_dir = root),
    "does not belong to type"
  )
  expect_error(
    palette_info("missing", palettes_dir = root),
    "not found in any type"
  )
})

test_that("ramp resampling uses the shared Lab interpolation space", {
  colors <- get_palette("mitonuclear_blue")
  positions <- seq(0, 1, length.out = 11)

  expect_identical(
    get_palette("mitonuclear_blue", n = 11),
    scales::gradient_n_pal(colors, space = "Lab")(positions)
  )
})

test_that("get_palette() validates name parameter", {
  expect_error(get_palette(123),             "single non-empty string")
  expect_error(get_palette(""),              "single non-empty string")
  expect_error(get_palette(NA_character_),   "single non-empty string")
  expect_error(get_palette(c("a", "b")),     "single non-empty string")
})

test_that("get_palette() validates type parameter", {
  expect_error(get_palette("gene_red", type = "invalid"), "should be one of")
})

test_that("get_palette() validates n parameter", {
  expect_error(get_palette("gene_red", type = "qualitative", n = 0),   "single positive integer")
  expect_error(get_palette("gene_red", type = "qualitative", n = -1),  "single positive integer")
  expect_error(get_palette("gene_red", type = "qualitative", n = 1.5), "single positive integer")
  expect_error(get_palette("gene_red", type = "qualitative", n = Inf), "single positive integer")
})

#==============================================================================
# get_palette() — reverse
#==============================================================================

test_that("reverse flips a palette end to end", {
  full <- get_palette("mitonuclear_blue")

  expect_identical(get_palette("mitonuclear_blue", reverse = TRUE), rev(full))
  expect_identical(get_palette("mitonuclear_blue", reverse = FALSE), full)
})

test_that("reverse is applied before n, for both kinds of palette", {
  # Reason: the documented order is reverse-then-n, so on a qualitative
  # palette n selects from the far end rather than re-ordering the near end.
  q <- get_palette("walter_white2")
  expect_identical(get_palette("walter_white2", reverse = TRUE, n = 2), rev(q)[1:2])

  # On a ramp the two orders agree, which is what makes the choice safe.
  s <- get_palette("mitonuclear_blue", reverse = TRUE, n = 3)
  expect_identical(s, rev(get_palette("mitonuclear_blue", n = 3)))
})

test_that("reverse keeps the ends of a stretched ramp", {
  full <- get_palette("walter_white", type = "diverging")
  nine <- get_palette("walter_white", type = "diverging", reverse = TRUE, n = 9)

  expect_length(nine, 9L)
  expect_identical(nine[1], full[5])
  expect_identical(nine[9], full[1])
})

test_that("reverse validates its input", {
  expect_error(get_palette("gene_red", reverse = "yes"), "TRUE or FALSE")
  expect_error(get_palette("gene_red", reverse = NA), "TRUE or FALSE")
  expect_error(get_palette("gene_red", reverse = c(TRUE, FALSE)), "TRUE or FALSE")
})

test_that("preview_palette() forwards reverse to get_palette()", {
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(grDevices::dev.off(), add = TRUE)

  # Reason: preview_palette() mirrors every retrieval argument, so a palette
  # get_palette() can return must be previewable too.
  expect_true("reverse" %in% names(formals(preview_palette)))
  expect_no_error(preview_palette("mitonuclear_blue", reverse = TRUE))
  expect_no_error(preview_palette("walter_white2", reverse = TRUE, n = 2))
})

#==============================================================================
# list_palettes()
#==============================================================================

test_that("list_palettes() returns data.frame with expected columns", {
  result <- list_palettes()
  expect_s3_class(result, "data.frame")
  expect_true(all(c("name", "type", "n_color", "colors") %in% names(result)))
  expect_true(nrow(result) > 0L)
})

test_that("list_palettes() filters by single type", {
  result <- list_palettes(type = "qualitative")
  expect_true(all(result$type == "qualitative"))
  expect_true(nrow(result) > 0L)
})

test_that("list_palettes() filters by multiple types", {
  result <- list_palettes(type = c("sequential", "diverging"))
  expect_true(all(result$type %in% c("sequential", "diverging")))
  expect_false("qualitative" %in% result$type)
})

test_that("list_palettes() sort=TRUE produces ordered output", {
  result <- list_palettes(sort = TRUE)
  sorted <- result[order(result$type, result$n_color, result$name), ]
  expect_equal(result$name, sorted$name)
})

test_that("list_palettes() sort=FALSE preserves original order", {
  sorted   <- list_palettes(sort = TRUE)
  unsorted <- list_palettes(sort = FALSE)
  expect_setequal(sorted$name, unsorted$name)
})

test_that("list_palettes() validates sort parameter", {
  expect_error(list_palettes(sort = "yes"), "TRUE or FALSE")
  expect_error(list_palettes(sort = NA),    "TRUE or FALSE")
})

test_that("list_palettes() row names are a clean sequence after sorting", {
  result <- list_palettes()
  expect_identical(row.names(result), as.character(seq_len(nrow(result))))
})

test_that("list_palettes() returns an empty data.frame when a type holds nothing", {
  # A collection carrying only one type, so asking for another finds nothing.
  root <- file.path(tempdir(), paste0("lp_empty_", Sys.getpid()))
  dir.create(file.path(root, "qualitative"), recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  jsonlite::write_json(
    list(name = "only_one", type = "qualitative", colors = c("#000000", "#FFFFFF")),
    path = file.path(root, "qualitative", "only_one.json"),
    pretty = TRUE, auto_unbox = TRUE
  )

  result <- list_palettes(type = "diverging", palettes_dir = root)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0L)
  expect_true(all(c("name", "type", "n_color", "colors") %in% names(result)))
  # The columns keep their types even when empty, so rbind-ing stays safe.
  expect_type(result$n_color, "integer")
})

#==============================================================================
# create_palette()
#==============================================================================

test_that("create_palette() creates JSON file in correct directory", {
  tmp <- file.path(tempdir(), paste0("cp_test_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  result <- suppressMessages(create_palette(
    "my_blues", "sequential",
    c("#deebf7", "#9ecae1", "#3182bd"),
    palettes_dir = tmp
  ))

  expect_type(result, "list")
  expect_true(file.exists(result$path))
  expect_match(result$path, "sequential")
  expect_match(result$path, "my_blues\\.json$")
})

test_that("create_palette() JSON content is correct", {
  tmp <- file.path(tempdir(), paste0("cp_json_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  colors <- c("#E64B35", "#4DBBD5", "#00A087")
  result <- suppressMessages(create_palette("qual_trio", "qualitative", colors, palettes_dir = tmp))

  parsed <- jsonlite::fromJSON(result$path)
  expect_equal(parsed$name,   "qual_trio")
  expect_equal(parsed$type,   "qualitative")
  expect_equal(parsed$colors, colors)
})

test_that("create_palette() errors when palette already exists without overwrite", {
  tmp <- file.path(tempdir(), paste0("cp_ow_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  suppressMessages(create_palette("blues", "sequential", c("#deebf7", "#9ecae1", "#3182bd"), palettes_dir = tmp))
  expect_error(
    create_palette("blues", "sequential", c("#c6dbef", "#6baed6", "#2171b5"), palettes_dir = tmp),
    "already exists"
  )
})

test_that("create_palette() overwrites when overwrite = TRUE", {
  tmp <- file.path(tempdir(), paste0("cp_owt_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  suppressMessages(create_palette("blues", "sequential", c("#deebf7", "#9ecae1", "#3182bd"), palettes_dir = tmp))
  new_colors <- c("#c6dbef", "#6baed6", "#2171b5")
  result <- suppressMessages(create_palette("blues", "sequential", new_colors, palettes_dir = tmp, overwrite = TRUE))

  parsed <- jsonlite::fromJSON(result$path)
  expect_equal(parsed$colors, new_colors)
})

test_that("create_palette() validates before replacing an existing file", {
  tmp <- file.path(tempdir(), paste0("atomic_validate_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  suppressMessages(create_palette(
    "stable", "qualitative", c("#111111", "#222222"),
    palettes_dir = tmp
  ))
  target <- file.path(tmp, "qualitative", "stable.json")
  before <- readLines(target, warn = FALSE)

  local_mocked_bindings(
    .read_palette_json = function(...) {
      list(ok = FALSE, problem = "simulated validation failure")
    }
  )

  expect_error(
    suppressMessages(create_palette(
      "stable", "qualitative", c("#AAAAAA", "#BBBBBB"),
      palettes_dir = tmp, overwrite = TRUE
    )),
    "failed validation.*simulated validation failure"
  )
  expect_identical(readLines(target, warn = FALSE), before)
})

test_that("failed fallback commit restores the previous file", {
  root <- file.path(tempdir(), paste0("atomic_commit_", Sys.getpid()))
  dir.create(root, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  source <- file.path(root, "new.json")
  target <- file.path(root, "palette.json")
  writeLines("new", source)
  writeLines("old", target)

  attempt <- 0L
  local_mocked_bindings(
    .rename_file = function(from, to) {
      attempt <<- attempt + 1L
      if (attempt %in% c(1L, 3L)) return(FALSE)
      file.rename(from, to)
    }
  )

  expect_error(
    biopalette:::.commit_palette_file(source, target),
    "previous file was restored"
  )
  expect_identical(readLines(target, warn = FALSE), "old")
  expect_true(file.exists(source))
})

test_that("atomic palette writes leave no temporary sibling files", {
  tmp <- file.path(tempdir(), paste0("atomic_clean_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  suppressMessages(create_palette(
    "clean", "sequential", c("#111111", "#EEEEEE"),
    palettes_dir = tmp
  ))

  files <- list.files(file.path(tmp, "sequential"), all.files = TRUE)
  expect_identical(files, c(".", "..", "clean.json"))
})

test_that("create_palette() validates name parameter", {
  tmp <- file.path(tempdir(), paste0("cp_val_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  expect_error(create_palette(123, "sequential", c("#FF0000"), palettes_dir = tmp),
               "single non-empty string")
  expect_error(create_palette("", "sequential",  c("#FF0000"), palettes_dir = tmp),
               "single non-empty string")
  expect_error(create_palette("GeneRed", "sequential", c("#FF0000"), palettes_dir = tmp),
               "snake_case palette name")
  expect_error(create_palette("gene-red", "sequential", c("#FF0000"), palettes_dir = tmp),
               "snake_case palette name")
  expect_error(create_palette("gene_red.json", "sequential", c("#FF0000"), palettes_dir = tmp),
               "snake_case palette name")
  expect_error(create_palette("../gene_red", "sequential", c("#FF0000"), palettes_dir = tmp),
               "snake_case palette name")
})

test_that("create_palette() validates colors are valid HEX", {
  tmp <- file.path(tempdir(), paste0("cp_hex_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  expect_error(
    create_palette("bad", "sequential", c("notahex"), palettes_dir = tmp),
    "invalid HEX codes"
  )
})

#==============================================================================
# remove_palette()
#==============================================================================

test_that("remove_palette() removes existing palette file and returns TRUE", {
  tmp <- file.path(tempdir(), paste0("rm_test_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  suppressMessages(create_palette("to_remove", "sequential", c("#deebf7", "#9ecae1"), palettes_dir = tmp))
  json_path <- file.path(tmp, "sequential", "to_remove.json")
  expect_true(file.exists(json_path))

  result <- suppressMessages(remove_palette("to_remove", type = "sequential", palettes_dir = tmp))
  expect_true(isTRUE(result))
  expect_false(file.exists(json_path))
})

test_that("remove_palette() returns FALSE when palette not found", {
  tmp <- file.path(tempdir(), paste0("rm_miss_", Sys.getpid()))
  dir.create(tmp, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  result <- suppressMessages(remove_palette("ghost_palette", palettes_dir = tmp))
  expect_false(isTRUE(result))
})

test_that("remove_palette() finds palette without specifying type", {
  tmp <- file.path(tempdir(), paste0("rm_auto_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  suppressMessages(create_palette("find_me", "diverging", c("#d73027", "#f7f7f7", "#4575b4"), palettes_dir = tmp))
  json_path <- file.path(tmp, "diverging", "find_me.json")
  expect_true(file.exists(json_path))

  result <- suppressMessages(remove_palette("find_me", palettes_dir = tmp))
  expect_true(isTRUE(result))
  expect_false(file.exists(json_path))
})

test_that("remove_palette() does not search other types when type is specified", {
  tmp <- file.path(tempdir(), paste0("rm_type_", Sys.getpid()))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  suppressMessages(create_palette("typed_only", "diverging", c("#d73027", "#f7f7f7", "#4575b4"), palettes_dir = tmp))
  json_path <- file.path(tmp, "diverging", "typed_only.json")
  expect_true(file.exists(json_path))

  result <- suppressMessages(remove_palette("typed_only", type = "qualitative", palettes_dir = tmp))
  expect_false(isTRUE(result))
  expect_true(file.exists(json_path))
})

test_that("remove_palette() validates name parameter", {
  tmp <- file.path(tempdir(), paste0("rm_val_", Sys.getpid()))
  dir.create(tmp, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  expect_error(remove_palette(123, palettes_dir = tmp),       "single non-empty string")
  expect_error(remove_palette("",  palettes_dir = tmp),       "single non-empty string")
  expect_error(remove_palette("GeneRed", palettes_dir = tmp), "snake_case palette name")
  expect_error(remove_palette("gene-red", palettes_dir = tmp), "snake_case palette name")
  expect_error(remove_palette("gene_red.json", palettes_dir = tmp), "snake_case palette name")
  expect_error(remove_palette("../gene_red", palettes_dir = tmp), "snake_case palette name")
})

#===============================================================================
# End: test-palette.R
#===============================================================================
