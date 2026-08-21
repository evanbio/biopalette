# =============================================================================
# store.R — Where palettes come from and how they are looked up
# =============================================================================

# Compiled palette collections, keyed by normalised directory path. Lives in the
# package namespace, so nothing is written to the user's environment or to disk.
# Each entry carries a stamp of the directory contents and is recompiled when
# that stamp changes.
.palette_cache <- new.env(parent = emptyenv())

# The three type subdirectories, in the order they appear in a collection.
.palette_types <- c("sequential", "diverging", "qualitative")


#' Directory holding the palettes that ship with the package
#'
#' Memoised: system.file() re-resolves the library path on every call, which
#' measured at ~0.7 ms — the single largest cost on an otherwise cached
#' get_palette(). The answer cannot change within a session.
#'
#' @return Character path, or "" when the package is not installed.
#'
#' @keywords internal
#' @noRd
.bundled_palettes_dir <- function() {
  if (is.null(.palette_cache$..bundled_dir)) {
    .palette_cache$..bundled_dir <- system.file("extdata", "palettes", package = "biopalette")
  }
  .palette_cache$..bundled_dir
}


#' List the palette JSON files under a collection directory
#'
#' @param palettes_dir Character. Collection root.
#' @return Character vector of paths, sorted, across all three type subdirs.
#'
#' @keywords internal
#' @noRd
.palette_json_files <- function(palettes_dir) {
  sort(unlist(lapply(.palette_types, function(type) {
    list.files(file.path(palettes_dir, type), pattern = "[.]json$", full.names = TRUE)
  })))
}


#' Fingerprint a set of palette files
#'
#' @param files Character vector of file paths.
#' @return A list used as an equality stamp.
#'
#' @keywords internal
#' @noRd
.palette_dir_stamp <- function(files) {
  # Reason: the cache has to notice edits made after a collection was first
  # read — most importantly a create_palette() call in the same session. Size
  # and mtime together catch writes without re-parsing anything.
  info <- file.info(files, extra_cols = FALSE)
  list(files = files, mtime = as.numeric(info$mtime), size = info$size)
}


#' Normalised cache key for a directory
#'
#' @param palettes_dir Character. Collection root.
#' @return Character scalar, or NULL when the path cannot be normalised.
#'
#' @keywords internal
#' @noRd
.palette_cache_key <- function(palettes_dir) {
  key <- tryCatch(
    normalizePath(palettes_dir, winslash = "/", mustWork = FALSE),
    error = function(e) NULL
  )
  if (is.null(key) || !nzchar(key)) return(NULL)
  key
}


#' Drop a directory from the palette cache
#'
#' Called after a write so the next read recompiles even if the filesystem
#' timestamp is too coarse to have moved.
#'
#' @param palettes_dir Character. Collection root.
#' @return Invisibly NULL.
#'
#' @keywords internal
#' @noRd
.invalidate_palette_cache <- function(palettes_dir) {
  key <- .palette_cache_key(palettes_dir)
  if (is.null(key)) return(invisible(NULL))

  keys <- key

  # Reason: the bundled collection is cached under a fixed key and is not
  # stamp-checked, so a write aimed at that same directory — which is exactly
  # what the curation workflow does under devtools::load_all() — has to drop
  # that entry explicitly or the next read would serve stale colors.
  bundled <- .bundled_palettes_dir()
  if (nzchar(bundled) && identical(key, .palette_cache_key(bundled))) {
    keys <- c(keys, "..bundled")
  }

  keys <- keys[vapply(keys, exists, logical(1),
                      envir = .palette_cache, inherits = FALSE)]
  if (length(keys)) rm(list = keys, envir = .palette_cache)

  invisible(NULL)
}


#' Read and validate one palette JSON file
#'
#' Never aborts. Returns either the palette or a description of what is wrong,
#' so the caller can report every bad file at once instead of stopping at the
#' first.
#'
#' @param json_file Character. Path to the JSON file.
#' @param type Character. The type subdirectory the file was found in.
#' @param expected_name Optional character scalar used as the expected file
#'   stem. This allows a temporary file to be validated before it is committed
#'   under its final palette name.
#' @return List with `ok`, plus either `palette` or `problem`.
#'
#' @keywords internal
#' @noRd
.read_palette_json <- function(json_file, type, expected_name = NULL) {

  bad  <- function(msg) list(ok = FALSE, problem = msg)
  stem <- if (is.null(expected_name)) {
    sub("[.]json$", "", basename(json_file))
  } else {
    expected_name
  }

  info <- tryCatch(jsonlite::fromJSON(json_file), error = function(e) e)
  if (inherits(info, "error")) {
    return(bad(paste0("not valid JSON (", conditionMessage(info), ")")))
  }

  missing_fields <- setdiff(c("name", "type", "colors"), names(info))
  if (length(missing_fields) > 0) {
    return(bad(paste0("missing field(s): ", paste(missing_fields, collapse = ", "))))
  }

  # Reason: JSON can carry an array under any key. Checking scalarness before
  # anything else keeps the comparisons below from receiving a length > 1
  # condition, which R reports as a bare "the condition has length > 1".
  for (field in c("name", "type")) {
    v <- info[[field]]
    if (!is.character(v) || length(v) != 1L || is.na(v) || !nzchar(v)) {
      return(bad(paste0("`", field, "` must be a single non-empty string")))
    }
  }

  if (!grepl("^[a-z][a-z0-9_]*$", info$name)) {
    return(bad(paste0("`name` '", info$name, "' is not snake_case")))
  }

  # The file stem is how a palette is located; the name is how it is looked up.
  # If they disagree, a palette that plainly exists becomes unfindable.
  if (!identical(info$name, stem)) {
    return(bad(paste0("`name` '", info$name, "' does not match the file stem '", stem, "'")))
  }

  if (!identical(info$type, type)) {
    return(bad(paste0("`type` '", info$type, "' does not match its directory '", type, "'")))
  }

  colors <- info$colors
  if (!is.character(colors) || length(colors) == 0L) {
    return(bad("`colors` must be a non-empty array of HEX strings"))
  }
  invalid <- !grepl("^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$", colors)
  if (any(invalid)) {
    return(bad(paste0("invalid HEX code(s): ", paste(colors[invalid], collapse = ", "))))
  }

  list(ok = TRUE, palette = list(name = info$name, type = type, colors = colors))
}


#' Compile every palette JSON under a directory
#'
#' Reads all three type subdirectories, validates each file, and assembles the
#' collection. Every problem found is reported together, and one bad file makes
#' the whole collection unusable — silently skipping it would turn a broken
#' palette into a puzzling "not found".
#'
#' @param palettes_dir Character. Collection root.
#' @return Named list with `sequential`, `diverging`, `qualitative`.
#'
#' @keywords internal
#' @noRd
.compile_palette_dir <- function(palettes_dir) {

  files <- .palette_json_files(palettes_dir)
  if (length(files) == 0) {
    cli::cli_abort(
      c("No palette JSON files under {.path {palettes_dir}}.",
        "i" = "Expected a {.path sequential/}, {.path diverging/} or {.path qualitative/} subdirectory."),
      call = NULL
    )
  }

  palettes <- list(sequential = list(), diverging = list(), qualitative = list())
  problems <- character(0)
  seen     <- character(0)

  for (f in files) {
    type <- basename(dirname(f))
    rel  <- file.path(type, basename(f))

    res <- .read_palette_json(f, type)
    if (!res$ok) {
      problems <- c(problems, paste0(rel, " - ", res$problem))
      next
    }

    nm <- res$palette$name
    if (nm %in% seen) {
      problems <- c(problems, paste0(rel, " - duplicate palette name '", nm, "'"))
      next
    }

    seen <- c(seen, nm)
    palettes[[type]][[nm]] <- res$palette$colors
  }

  if (length(problems) > 0) {
    n_problems <- length(problems)

    # Reason: these strings carry file names and parser output, which can
    # contain braces — a JSON parse error is literally "Expecting '}'". cli
    # runs its input through glue, so an unescaped brace would be read as an
    # interpolation and swallow the message. Doubling them escapes them.
    problems <- gsub("}", "}}", gsub("{", "{{", problems, fixed = TRUE), fixed = TRUE)

    # Naming each element "*" turns it into a cli bullet, so every bad file is
    # listed at once rather than one abort per rerun.
    names(problems) <- rep("*", n_problems)

    cli::cli_abort(
      c("{n_problems} palette file{?s} in {.path {palettes_dir}} could not be loaded:",
        problems),
      call = NULL
    )
  }

  palettes
}


#' Load a palette collection
#'
#' Returns the collection under `palettes_dir`, or the palettes bundled with the
#' package when that is NULL. Results are cached per directory and recompiled
#' when the files on disk change, so repeated lookups cost nothing.
#'
#' Everything resolves from an explicit directory or from the installed package.
#' Nothing resolves relative to the working directory, so the result never
#' depends on where the user happens to be sitting.
#'
#' @param palettes_dir Character or NULL. Collection root.
#' @return Named list of palettes keyed by type.
#'
#' @keywords internal
#' @noRd
.load_palettes <- function(palettes_dir = NULL) {

  bundled <- is.null(palettes_dir)

  if (bundled) {
    palettes_dir <- .bundled_palettes_dir()
    if (!nzchar(palettes_dir)) {
      cli::cli_abort(
        "The bundled palette library is unavailable. Is {.pkg biopalette} installed correctly?",
        call = NULL
      )
    }
    # Reason: the bundled collection lives inside the installed package, so it
    # cannot change while the session runs. Skipping the stamp saves a
    # list.files() plus a stat per file (~1.1 ms) on the hottest path in the
    # package. devtools::load_all() rebuilds the namespace, and with it this
    # cache, so a curator editing inst/extdata still sees fresh data.
    key <- "..bundled"
  } else {
    .assert_path_string(palettes_dir, arg = "palettes_dir")
    key <- .palette_cache_key(palettes_dir)
  }

  if (!dir.exists(palettes_dir)) {
    cli::cli_abort("Palette directory does not exist: {.path {palettes_dir}}", call = NULL)
  }

  stamp <- if (bundled) NULL else .palette_dir_stamp(.palette_json_files(palettes_dir))

  if (!is.null(key) && exists(key, envir = .palette_cache, inherits = FALSE)) {
    hit <- get(key, envir = .palette_cache, inherits = FALSE)
    if (bundled || identical(hit$stamp, stamp)) return(hit$palettes)
  }

  palettes <- .compile_palette_dir(palettes_dir)

  if (!is.null(key)) {
    assign(key, list(stamp = stamp, palettes = palettes), envir = .palette_cache)
  }

  palettes
}


#' Find which type(s) a palette name belongs to
#'
#' @param name Character. Palette name to search for.
#' @param palettes List. Compiled palette data (keyed by type).
#' @return Character vector of matching type names, or NULL if not found.
#'
#' @keywords internal
#' @noRd
.find_palette_type <- function(name, palettes) {
  types <- names(palettes)

  # Reason: vapply pins the result to a logical vector. sapply would hand back
  # a list the moment `types` is empty, and indexing by a list errors instead
  # of falling through to the NULL return below.
  hit <- vapply(
    types,
    function(t) name %in% names(palettes[[t]]),
    logical(1),
    USE.NAMES = FALSE
  )

  found <- types[hit]
  if (length(found) == 0) return(NULL)
  found
}


#' Resolve one palette from a collection
#'
#' This is the single lookup path for public palette consumers. It validates
#' the lookup arguments, resolves an omitted type, and returns both metadata
#' and colors so callers never have to load and search the collection again.
#'
#' @param name Character. Palette name.
#' @param type Character or NULL. Palette type.
#' @param palettes_dir Character or NULL. Collection root.
#' @return List with `name`, `type`, and `colors`.
#'
#' @keywords internal
#' @noRd
.resolve_palette <- function(name, type = NULL, palettes_dir = NULL) {
  .assert_scalar_string(name)
  if (!is.null(type)) {
    type <- match.arg(type, .palette_types)
  }

  palettes <- .load_palettes(palettes_dir)

  if (is.null(type)) {
    type <- .find_palette_type(name, palettes)
    if (is.null(type)) {
      cli::cli_abort("Palette {.val {name}} not found in any type.", call = NULL)
    }
    # Duplicate names are rejected while the collection is compiled, so a
    # successful lookup has exactly one type and needs no tie-breaking policy.
    type <- type[[1]]
  } else if (!name %in% names(palettes[[type]])) {
    found <- .find_palette_type(name, palettes)
    if (is.null(found)) {
      cli::cli_abort("Palette {.val {name}} not found in any type.", call = NULL)
    }
    cli::cli_abort(
      c("Palette {.val {name}} does not belong to type {.val {type}}.",
        "i" = "It belongs to {.val {found[[1]]}}; use that type or omit {.arg type}."),
      call = NULL
    )
  }

  list(
    name = name,
    type = type,
    colors = palettes[[type]][[name]]
  )
}


#' Return an empty palette metadata data.frame
#'
#' @return Empty data.frame with columns: name, type, n_color, colors.
#'
#' @keywords internal
#' @noRd
.empty_palette_df <- function() {
  data.frame(
    name    = character(),
    type    = character(),
    n_color = integer(),
    colors  = I(list()),
    stringsAsFactors = FALSE
  )
}
