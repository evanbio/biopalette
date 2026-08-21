# =============================================================================
# zzz.R — Package startup
# =============================================================================

#' Is this an interactive session?
#'
#' Thin wrapper over \code{interactive()}. Exists as a seam the tests can mock —
#' \code{testthat::local_mocked_bindings()} can only rebind names that live in
#' this package's namespace, not base ones.
#'
#' @return Logical scalar.
#'
#' @keywords internal
#' @noRd
.is_interactive <- function() {
  interactive()
}


.onAttach <- function(libname, pkgname) {
  if (!.is_interactive()) return(invisible(NULL))

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
