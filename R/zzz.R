# =============================================================================
# zzz.R - Package startup
# =============================================================================

.onAttach <- function(libname, pkgname) {
  if (!interactive()) return(invisible(NULL))

  # Reason: routed through packageStartupMessage() so the banner obeys
  # suppressPackageStartupMessages(). cli's own output functions signal a
  # plain message, which that suppressor does not catch.
  packageStartupMessage(cli::format_inline(
    "Welcome to {pkgname}. Version: {utils::packageVersion(pkgname)}"
  ))
  packageStartupMessage(cli::format_inline(
    "Tip: type {.code palette_gallery()} to browse all palettes."
  ))

  invisible(NULL)
}


# =============================================================================
# Globals for NSE (silence R CMD check notes)
# =============================================================================
utils::globalVariables(c("x", "y", "color", "name"))
