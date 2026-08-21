# =============================================================================
# palette.R — Color palette management functions
# =============================================================================


#' Get a Color Palette
#'
#' Retrieve a named palette by name and type, returning a vector of HEX colors.
#' Automatically checks for type mismatch and provides smart suggestions.
#'
#' @section What `n` means:
#'
#' `n` is resolved according to what the palette's type says the colors *are*,
#' because "give me 3 colors" means two different things:
#'
#' \describe{
#'   \item{`qualitative`}{The colors are unordered categories, so `n` takes the
#'     first `n` of them. Asking for more than the palette holds is an error —
#'     there is no way to invent a category that the palette does not contain.}
#'   \item{`sequential`, `diverging`}{The colors are stops along a ramp, so `n`
#'     returns `n` steps spanning the *whole* ramp, interpolating as needed.
#'     Interpolation takes place in Lab colour space, matching the package's
#'     ggplot2 gradient scales.
#'     Any `n` works, above or below the number of stops. Taking the first `n`
#'     stops instead would silently hand back one end of the ramp — the light
#'     half of a sequential scale, or one arm of a diverging one.}
#' }
#'
#' `n` equal to the number of stops returns the palette untouched. When
#' `reverse = TRUE` the palette is flipped first, so `n` selects from the
#' reversed palette.
#'
#' @param name Character. Name of the palette (e.g. "qual_vivid").
#' @param type Character. One of "sequential", "diverging", "qualitative". If NULL, type is auto-detected.
#' @param n Integer. Number of colors to return. If NULL, returns all colors.
#'   See *What `n` means* above. Default is NULL.
#' @param reverse Logical. Reverse the palette before `n` is applied, so the
#'   two arguments stay independent: `reverse` hands back a different palette
#'   and `n` then selects from it. Default: FALSE.
#' @param palettes_dir Character. Directory holding a palette collection
#'   (`sequential/`, `diverging/`, `qualitative/` subdirectories of JSON files).
#'   If NULL, the palettes bundled with the package are used.
#'
#' @return Character vector of HEX color codes.
#'
#' @examples
#' get_palette("gene_red", type = "qualitative")
#'
#' # Qualitative: the first n categories
#' get_palette("walter_white2", type = "qualitative", n = 2)
#'
#' # Sequential: n steps across the whole ramp, not the first n stops
#' get_palette("mitonuclear_blue")
#' get_palette("mitonuclear_blue", n = 3)
#'
#' # Ramps can also be stretched beyond the stops they were drawn from
#' get_palette("walter_white", type = "diverging", n = 9)
#'
#' # Flip a ramp end to end
#' get_palette("mitonuclear_blue", reverse = TRUE)
#'
#' @export
get_palette <- function(name,
                        type = NULL,
                        n = NULL,
                        reverse = FALSE,
                        palettes_dir = NULL) {

  if (!is.null(n)) .assert_count(n)
  .assert_flag(reverse)

  palette <- .resolve_palette(name, type, palettes_dir)
  .palette_colors(palette, n = n, reverse = reverse)
}


#' Get Metadata for One Color Palette
#'
#' Return the runtime metadata for a single named palette. This is the
#' one-palette counterpart to [list_palettes()] and uses the same lookup rules
#' as [get_palette()].
#'
#' @param name Character. Palette name.
#' @param type Character. One of `"sequential"`, `"diverging"`, or
#'   `"qualitative"`. If `NULL`, the type is detected automatically.
#' @param palettes_dir Character. Directory holding a palette collection. If
#'   `NULL`, the palettes bundled with the package are used.
#'
#' @return A one-row data.frame with columns `name`, `type`, `n_color`, and
#'   `colors`. The `colors` column is a list-column containing the complete HEX
#'   color vector.
#'
#' @examples
#' palette_info("walter_white")
#' palette_info("babel", type = "qualitative")
#'
#' @export
palette_info <- function(name, type = NULL, palettes_dir = NULL) {
  palette <- .resolve_palette(name, type, palettes_dir)

  data.frame(
    name = palette$name,
    type = palette$type,
    n_color = length(palette$colors),
    colors = I(list(unname(palette$colors))),
    stringsAsFactors = FALSE
  )
}


#' Select colors from a resolved palette
#'
#' @param palette List returned by [.resolve_palette()].
#' @param n Integer or NULL. Number of colors.
#' @param reverse Logical. Reverse before selecting colors.
#' @return Character vector of HEX colors.
#'
#' @keywords internal
#' @noRd
.palette_colors <- function(palette, n = NULL, reverse = FALSE) {
  colors <- palette$colors

  # Reason: reversing before `n` is applied keeps the two arguments independent
  # — `reverse` hands back a different palette, and `n` then selects from it.
  # Doing it the other way round would make `n` decide which end of a
  # qualitative palette `reverse` is allowed to see.
  if (reverse) colors <- rev(colors)

  # Reason: returning early also guarantees the palette comes back byte for
  # byte. colorRampPalette() would rebuild it and normalise the hex codes to
  # upper case along the way, so get_palette(x, n = length(x)) would not match
  # get_palette(x).
  if (is.null(n) || n == length(colors)) return(colors)

  if (palette$type == "qualitative") {
    if (n > length(colors)) {
      cli::cli_abort(
        c("Palette {.val {palette$name}} only has {.val {length(colors)}} colors, but {.val {n}} were requested.",
          "i" = "{.val qualitative} palettes are unordered categories, so they cannot be interpolated."),
        call = NULL
      )
    }
    return(colors[seq_len(n)])
  }

  .ramp_colors(colors, n)
}


#' List Available Color Palettes
#'
#' Return a data.frame of all available palette metadata, optionally filtered by type.
#'
#' @param type Palette type(s) to filter: `"sequential"`, `"diverging"`, `"qualitative"`. Default NULL returns all.
#' @param sort Whether to sort by type, n_color, name. Default: TRUE.
#' @param palettes_dir Character. Directory holding a palette collection
#'   (`sequential/`, `diverging/`, `qualitative/` subdirectories of JSON files).
#'   If NULL, the palettes bundled with the package are used.
#'
#' @return A `data.frame` with columns: `name`, `type`, `n_color`, `colors`.
#' @export
#'
#' @examples
#' list_palettes()
#' list_palettes(type = "qualitative")
#' list_palettes(type = c("sequential", "diverging"))
list_palettes <- function(type = NULL,
                          sort = TRUE,
                          palettes_dir = NULL) {

  # Validate inputs
  .assert_flag(sort)

  palettes <- .load_palettes(palettes_dir)

  # Resolve type: NULL means all available types
  if (!is.null(type)) {
    type <- match.arg(type, c("sequential", "diverging", "qualitative"), several.ok = TRUE)
  } else {
    type <- names(palettes)
  }

  # Reason: a collection always carries all three type slots, so `type` is
  # already guaranteed to name real slots by match.arg() above. A slot can be
  # empty, which falls through to the empty data.frame below.
  # Build palette metadata data.frame
  palette_df <- do.call(rbind, lapply(type, function(t) {
    pset <- palettes[[t]]
    if (length(pset) == 0) return(NULL)
    data.frame(
      name    = names(pset),
      type    = t,
      # Reason: unname() keeps lengths()'s names off the data.frame, which
      # would otherwise become row names duplicating the `name` column.
      n_color = unname(lengths(pset)),
      colors  = I(unname(pset)),
      stringsAsFactors = FALSE
    )
  }))

  if (is.null(palette_df)) return(.empty_palette_df())

  if (sort) {
    palette_df <- palette_df[
      order(palette_df$type, palette_df$n_color, palette_df$name),
    ]
  }

  # Reason: subsetting carries the pre-sort positions along as row names,
  # which print as a jumbled sequence (1, 2, 4, 5, 6, 3).
  row.names(palette_df) <- NULL

  palette_df
}


#' Create and Save a Custom Color Palette
#'
#' Save a named color palette as a JSON file in a collection directory. The
#' palette is usable immediately: point any reading function at the same
#' `palettes_dir`. The JSON is written to a same-directory temporary file,
#' validated, and then committed; a failed overwrite leaves the previous
#' palette intact.
#'
#' @param name Character. Palette name (e.g., "blues").
#' @param type Character. One of "sequential", "diverging", or "qualitative".
#' @param colors Character vector of HEX color values (e.g., "#E64B35" or "#E64B35B2").
#' @param palettes_dir Character. Directory to write the palette into. Required:
#'   there is deliberately no default, so a palette can never be written into
#'   the collection that ships with the package.
#' @param overwrite Logical. If TRUE, overwrite existing palette file. Default: FALSE.
#'
#' @return Invisibly returns a list with `path` and `info`.
#' @export
#'
#' @examples
#' temp_dir <- file.path(tempdir(), "palettes")
#' create_palette("blues", "sequential", c("#deebf7", "#9ecae1", "#3182bd"),
#'   palettes_dir = temp_dir)
#' create_palette("qual_vivid", "qualitative", c("#E64B35", "#4DBBD5", "#00A087"),
#'   palettes_dir = temp_dir)
#'
#' # Overwrite an existing palette explicitly
#' create_palette("blues", "sequential", c("#c6dbef", "#6baed6", "#2171b5"),
#'   palettes_dir = temp_dir, overwrite = TRUE)
#'
#' unlink(temp_dir, recursive = TRUE)
create_palette <- function(name,
                           type = c("sequential", "diverging", "qualitative"),
                           colors,
                           palettes_dir,
                           overwrite = FALSE) {

  # Validate inputs
  .assert_palette_name(name)
  type <- match.arg(type)
  .assert_hex_colors(colors)
  .assert_path_string(palettes_dir)
  .assert_flag(overwrite)

  # Create type subdirectory if needed
  palette_dir <- file.path(palettes_dir, type)
  if (!dir.exists(palette_dir)) {
    ok <- dir.create(palette_dir, recursive = TRUE, showWarnings = FALSE)
    if (!ok) cli::cli_abort("Failed to create directory: {.path {palette_dir}}", call = NULL)
  }

  json_file <- file.path(palette_dir, paste0(name, ".json"))
  palette_info <- list(name = name, type = type, colors = colors)

  # Guard against accidental overwrite
  if (file.exists(json_file)) {
    if (!overwrite) {
      cli::cli_abort("Palette {.val {name}} already exists. Use {.code overwrite = TRUE} to replace.", call = NULL)
    }
    cli::cli_alert_info("Overwriting existing palette: {.val {name}}")
  }

  .write_palette_json_atomic(palette_info, json_file, type)
  cli::cli_alert_success("Palette saved: {.file {json_file}}")

  # Reason: a get_palette() in the same session has to see what was just
  # written. The stamp check would normally catch it, but filesystem timestamp
  # resolution can be coarser than the gap between two adjacent calls.
  .invalidate_palette_cache(palettes_dir)

  invisible(list(path = json_file, info = palette_info))
}


#' Write and validate a palette JSON before committing it
#'
#' The temporary file is created beside the target, so a rename stays on the
#' same filesystem. Nothing touches an existing target until writing and full
#' palette validation have both succeeded.
#'
#' @param palette_info List containing `name`, `type`, and `colors`.
#' @param json_file Final target path.
#' @param type Palette type.
#' @return Invisibly `json_file`.
#'
#' @keywords internal
#' @noRd
.write_palette_json_atomic <- function(palette_info, json_file, type) {
  temp_file <- tempfile(
    pattern = paste0(".", palette_info$name, "-"),
    tmpdir = dirname(json_file),
    fileext = ".json"
  )
  on.exit(if (file.exists(temp_file)) unlink(temp_file), add = TRUE)

  tryCatch(
    jsonlite::write_json(
      palette_info,
      path = temp_file,
      pretty = TRUE,
      auto_unbox = TRUE
    ),
    error = function(e) {
      cli::cli_abort("Failed to write JSON: {e$message}", call = NULL)
    }
  )

  validation <- .read_palette_json(
    temp_file,
    type,
    expected_name = palette_info$name
  )
  if (!validation$ok) {
    cli::cli_abort(
      "Palette JSON failed validation before it could be saved: {validation$problem}",
      call = NULL
    )
  }

  .commit_palette_file(temp_file, json_file)
  invisible(json_file)
}


#' Commit a validated temporary palette file
#'
#' A same-directory rename is atomic on platforms that support replacing an
#' existing target. Windows commonly does not, so the fallback moves the old
#' target to a same-directory backup and restores it if the second move fails.
#'
#' @param source Validated temporary file.
#' @param target Final JSON path.
#' @return Invisibly `target`.
#'
#' @keywords internal
#' @noRd
.rename_file <- function(from, to) {
  file.rename(from, to)
}


#' @keywords internal
#' @noRd
.commit_palette_file <- function(source, target) {
  if (isTRUE(suppressWarnings(.rename_file(source, target)))) {
    return(invisible(target))
  }

  if (!file.exists(target)) {
    cli::cli_abort("Failed to commit palette JSON to {.file {target}}.", call = NULL)
  }

  backup <- tempfile(
    pattern = paste0(".", basename(target), "-backup-"),
    tmpdir = dirname(target)
  )

  if (!isTRUE(suppressWarnings(.rename_file(target, backup)))) {
    cli::cli_abort(
      "Failed to preserve the existing palette before replacing {.file {target}}.",
      call = NULL
    )
  }

  committed <- FALSE
  on.exit({
    if (!committed && file.exists(backup) && !file.exists(target)) {
      suppressWarnings(.rename_file(backup, target))
    }
  }, add = TRUE)

  if (!isTRUE(suppressWarnings(.rename_file(source, target)))) {
    restored <- isTRUE(suppressWarnings(.rename_file(backup, target)))
    if (!restored) {
      cli::cli_abort(
        c("Failed to commit palette JSON and restore the previous file.",
          "i" = "The previous file remains at {.file {backup}}."),
        call = NULL
      )
    }
    cli::cli_abort(
      "Failed to commit palette JSON; the previous file was restored.",
      call = NULL
    )
  }

  committed <- TRUE
  if (file.exists(backup) && !isTRUE(unlink(backup) == 0L)) {
    cli::cli_warn("Palette was saved, but backup file {.file {backup}} could not be removed.")
  }

  invisible(target)
}


#' Preview a Color Palette
#'
#' Visualize a palette using various plot styles.
#'
#' `"bar"`, `"pie"`, `"point"` and `"circle"` are drawn with base graphics;
#' `"rect"` is drawn with ggplot2. Either way the plot goes straight to the
#' active device and nothing is returned — use [palette_gallery()] when you
#' want plot objects you can modify, arrange or save.
#'
#' @param name Character. Name of the palette.
#' @param type Character. One of "sequential", "diverging", "qualitative". If NULL, auto-detected.
#' @param n Integer. Number of colors to use. If NULL, uses all. Default: NULL.
#' @param reverse Logical. Reverse the palette before `n` is applied. Passed
#'   straight through to [get_palette()]. Default: FALSE.
#' @param plot_type Character. One of "bar", "pie", "point", "rect", "circle". Default: "bar".
#' @param title Character. Plot title. If NULL, defaults to palette name.
#' @param palettes_dir Character. Directory holding a palette collection
#'   (`sequential/`, `diverging/`, `qualitative/` subdirectories of JSON files).
#'   If NULL, the palettes bundled with the package are used.
#'
#' @return `NULL`, invisibly. Called for its plotting side effect — the return
#'   shape is the same for every `plot_type`.
#'
#' @seealso [palette_gallery()], which returns ggplot objects instead of drawing.
#'
#' @export
#'
#' @examples
#' \donttest{
#' preview_palette("gene_red", plot_type = "bar")
#' preview_palette("walter_white", plot_type = "pie")
#' preview_palette("walter_white2", n = 2, plot_type = "circle")
#' }
preview_palette <- function(name,
                            type = NULL,
                            n = NULL,
                            reverse = FALSE,
                            plot_type = c("bar", "pie", "point", "rect", "circle"),
                            title = NULL,
                            palettes_dir = NULL) {

  plot_type <- match.arg(plot_type)
  if (is.null(title)) title <- name else .assert_scalar_string(title)

  colors <- get_palette(name = name, type = type, n = n,
                        reverse = reverse, palettes_dir = palettes_dir)
  .preview_draw(colors, plot_type, title)

  invisible(NULL)
}


#' Visualize All Palettes in a Gallery View
#'
#' Display palettes in a paged gallery format, returning a named list of ggplot objects.
#'
#' @param type Palette types to include: "sequential", "diverging", "qualitative". Default NULL returns all.
#' @param max_palettes Number of palettes per page. Default: 30.
#' @param max_row Max colors per row. Default: 12.
#' @param verbose Whether to print progress info. Default: TRUE.
#' @param palettes_dir Character. Directory holding a palette collection
#'   (`sequential/`, `diverging/`, `qualitative/` subdirectories of JSON files).
#'   If NULL, the palettes bundled with the package are used.
#'
#' @return A named list of ggplot objects (one per page).
#' @export
#'
#' @examples
#' \donttest{
#' palette_gallery()
#' palette_gallery(type = "qualitative")
#' palette_gallery(type = c("sequential", "diverging"), max_palettes = 10)
#' }
palette_gallery <- function(type = NULL,
                            max_palettes = 30,
                            max_row = 12,
                            verbose = TRUE,
                            palettes_dir = NULL) {

  # Validate inputs
  .assert_count(max_palettes)
  .assert_count(max_row)
  .assert_flag(verbose)

  palettes <- .load_palettes(palettes_dir)

  # Resolve type: NULL means all available types
  if (!is.null(type)) {
    type <- match.arg(type, c("sequential", "diverging", "qualitative"), several.ok = TRUE)
  } else {
    type <- names(palettes)
  }

  selected_types <- intersect(type, names(palettes))
  if (length(selected_types) == 0) return(list())

  plots <- list()

  for (type_val in selected_types) {
    pal_data <- palettes[[type_val]]

    if (is.null(pal_data) || length(pal_data) == 0) next

    pal_info <- data.frame(name = names(pal_data), n = lengths(pal_data))
    pal_info <- pal_info[order(-pal_info$n, pal_info$name), ]

    total <- nrow(pal_info)
    pages <- ceiling(total / max_palettes)

    if (verbose) cli::cli_alert_info("Type {.strong {type_val}}: {total} palettes -> {pages} page(s)")

    for (pg in seq_len(pages)) {
      idx  <- ((pg - 1) * max_palettes + 1):min(pg * max_palettes, total)
      rows <- pal_info[idx, ]

      page  <- .gallery_page_data(rows, pal_data, type_val, max_row)
      p     <- .gallery_page_plot(page$plot_data, page$label_data)
      key   <- paste0(type_val, "_page", pg)
      plots[[key]] <- p

      if (verbose) cli::cli_alert_success("Built {.val {key}}")
    }
  }

  plots
}


#' Remove a Saved Palette JSON
#'
#' Remove a palette JSON file by name, searching across types if needed.
#'
#' @param name Character. Palette name (without '.json' suffix).
#' @param type Character. One of "sequential", "diverging", "qualitative". If NULL, searches all types.
#' @param palettes_dir Character. Directory holding the palette collection.
#'   Required: there is deliberately no default, so the collection that ships
#'   with the package can never be removed from.
#'
#' @return Invisibly TRUE if removed successfully, FALSE otherwise.
#' @export
#'
#' @examples
#' temp_dir <- tempfile("biopalette-palettes-")
#' create_palette(
#'   "example_palette",
#'   "qualitative",
#'   c("#E64B35", "#4DBBD5", "#00A087"),
#'   palettes_dir = temp_dir
#' )
#'
#' remove_palette("example_palette", palettes_dir = temp_dir)
#' unlink(temp_dir, recursive = TRUE)
remove_palette <- function(name,
                           type = NULL,
                           palettes_dir) {

  # Validate inputs
  .assert_palette_name(name)
  .assert_path_string(palettes_dir)
  if (!is.null(type)) type <- match.arg(type, c("sequential", "diverging", "qualitative"))

  # Search only the requested type when specified; otherwise search all types.
  valid_types <- c("sequential", "diverging", "qualitative")
  types_to_try <- if (is.null(type)) valid_types else type

  for (current_type in types_to_try) {
    json_file <- file.path(palettes_dir, current_type, paste0(name, ".json"))

    if (file.exists(json_file)) {
      ok <- tryCatch({
        isTRUE(file.remove(json_file))
      }, error = function(e) {
        cli::cli_alert_warning("Failed to remove: {.file {json_file}} - {e$message}")
        FALSE
      })

      if (ok) {
        cli::cli_alert_success("Removed {.val {name}} from {.strong {current_type}}")
        .invalidate_palette_cache(palettes_dir)
        return(invisible(TRUE))
      }
    }
  }

  cli::cli_alert_warning("Palette {.val {name}} not found in any type.")
  invisible(FALSE)
}
