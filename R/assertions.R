# =============================================================================
# assertions.R — Input validation helpers
# =============================================================================


#' Assert that an argument is a single non-empty string
#'
#' @param x The argument to check.
#' @param arg Name of the argument (for error messages).
#' @return Invisibly returns \code{x}.
#'
#' @keywords internal
#' @noRd
.assert_scalar_string <- function(x, arg = deparse1(substitute(x))) {
  if (!is.character(x) || length(x) != 1L || is.na(x) || !nzchar(x)) {
    cli::cli_abort("{.arg {arg}} must be a single non-empty string.", call = NULL)
  }
  invisible(x)
}


#' Assert that an argument is a valid path string
#'
#' Same check as \code{.assert_scalar_string()} — it validates the string, not
#' the filesystem. The separate name marks call sites where that string will be
#' used as a file or directory path; nothing is required to exist there.
#'
#' @param x The argument to check.
#' @param arg Name of the argument (for error messages).
#' @return Invisibly returns \code{x}.
#'
#' @keywords internal
#' @noRd
.assert_path_string <- function(x, arg = deparse1(substitute(x))) {
  .assert_scalar_string(x, arg = arg)
}


#' Assert that an argument is a single logical flag (TRUE or FALSE)
#'
#' @param x The argument to check.
#' @param arg Name of the argument (for error messages).
#' @return Invisibly returns \code{x}.
#'
#' @keywords internal
#' @noRd
.assert_flag <- function(x, arg = deparse1(substitute(x))) {
  if (!is.logical(x) || length(x) != 1L || is.na(x)) {
    cli::cli_abort("{.arg {arg}} must be TRUE or FALSE.", call = NULL)
  }
  invisible(x)
}


#' Assert that an argument is a single positive integer (count parameter)
#'
#' @param x The argument to check.
#' @param arg Name of the argument (for error messages).
#' @return Invisibly returns \code{as.integer(x)}.
#'
#' @keywords internal
#' @noRd
.assert_count <- function(x, arg = deparse1(substitute(x))) {
  # Reason: is.finite() required because floor(Inf) == Inf, so without it
  # Inf would silently pass the floor check
  if (!is.numeric(x) || length(x) != 1L || is.na(x) ||
      !is.finite(x) || x < 1L || x != floor(x)) {
    cli::cli_abort("{.arg {arg}} must be a single positive integer.", call = NULL)
  }
  invisible(as.integer(x))
}


#' Assert that all values are valid HEX color codes
#'
#' @param x Character vector of HEX color codes.
#' @param arg Name of the argument (for error messages).
#'
#' @keywords internal
#' @noRd
.assert_hex_colors <- function(x, arg = deparse1(substitute(x))) {
  if (!is.character(x) || length(x) == 0) {
    cli::cli_abort("{.arg {arg}} must be a non-empty character vector of HEX codes.", call = NULL)
  }
  invalid <- !grepl("^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$", x)
  if (any(invalid)) {
    cli::cli_abort("{.arg {arg}} contains invalid HEX codes: {.val {x[invalid]}}.", call = NULL)
  }
  invisible(x)
}


#' Assert that a numeric vector is a valid RGB or RGBA value
#'
#' @param x Numeric vector of length 3 or 4 with values in [0, 255].
#' @param arg Name of the argument (for error messages).
#'
#' @keywords internal
#' @noRd
.assert_rgb_vector <- function(x, arg = deparse1(substitute(x))) {
  if (!is.numeric(x) || !is.null(dim(x)) || !length(x) %in% c(3L, 4L)) {
    cli::cli_abort("{.arg {arg}} must be a numeric vector of length 3 or 4.", call = NULL)
  }
  if (anyNA(x) || any(!is.finite(x))) {
    cli::cli_abort("{.arg {arg}} must not contain NA, Inf, or NaN.", call = NULL)
  }
  if (any(x < 0 | x > 255)) {
    cli::cli_abort("{.arg {arg}} values must be in [0, 255].", call = NULL)
  }
  invisible(x)
}


#' Assert that a data.frame has valid r, g, b and optional alpha columns
#'
#' @param x data.frame with columns r, g, b and optional alpha.
#' @param arg Name of the argument (for error messages).
#'
#' @keywords internal
#' @noRd
.assert_rgb_df <- function(x, arg = deparse1(substitute(x))) {
  if (!is.data.frame(x)) {
    cli::cli_abort("{.arg {arg}} must be a data.frame.", call = NULL)
  }
  if (nrow(x) == 0L) {
    cli::cli_abort("{.arg {arg}} must contain at least one row.", call = NULL)
  }
  missing_cols <- setdiff(c("r", "g", "b"), names(x))
  if (length(missing_cols) > 0) {
    cli::cli_abort("{.arg {arg}} must have columns {.val {c('r', 'g', 'b')}}. Missing: {.val {missing_cols}}.", call = NULL)
  }
  for (col in c("r", "g", "b")) {
    vals <- x[[col]]
    if (!is.numeric(vals) || anyNA(vals) || any(!is.finite(vals)) || any(vals < 0 | vals > 255)) {
      cli::cli_abort("Column {.val {col}} in {.arg {arg}} must be numeric with values in [0, 255].", call = NULL)
    }
  }

  if ("alpha" %in% names(x)) {
    alpha <- x$alpha
    present <- !is.na(alpha)
    if (!(is.numeric(alpha) || all(is.na(alpha))) ||
        any(!is.finite(alpha[present])) ||
        any(alpha[present] < 0 | alpha[present] > 255)) {
      cli::cli_abort(
        "Column {.val alpha} in {.arg {arg}} must contain NA or numeric values in [0, 255].",
        call = NULL
      )
    }
  }
  invisible(x)
}


#' Assert that a palette name is safe for JSON file naming
#'
#' Palette names are also used as JSON file stems under type directories.
#'
#' @param x Character. Palette name.
#' @param arg Name of the argument (for error messages).
#'
#' @keywords internal
#' @noRd
.assert_palette_name <- function(x, arg = deparse1(substitute(x))) {
  .assert_scalar_string(x, arg = arg)

  if (!grepl("^[a-z][a-z0-9_]*$", x)) {
    cli::cli_abort(
      "{.arg {arg}} must be a snake_case palette name, e.g. {.val gene_red}.",
      call = NULL
    )
  }

  invisible(x)
}
