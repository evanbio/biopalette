# =============================================================================
# zzz.R - Package startup
# =============================================================================

# =============================================================================
# Package Load / Attach Hooks
# =============================================================================

.onLoad <- function(libname, pkgname) {
  invisible(NULL)
}

.onAttach <- function(libname, pkgname) {
  if (!interactive()) return()
  version <- utils::packageVersion(pkgname)
  cli::cli_text("Welcome to {pkgname}.")
  cli::cli_text("Version: {version}")
  cli::cli_text("Tip: type {cli::col_blue('palette_gallery()')} to browse all palettes.")
}


# =============================================================================
# Globals for NSE (silence R CMD check notes)
# =============================================================================
utils::globalVariables(c("x", "y", "color", "name"))
