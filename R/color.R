# =============================================================================
# color.R — HEX and RGB color conversion
# =============================================================================

# Interpolation space shared by palette resampling and ggplot2 gradients. Lab
# keeps the two public paths perceptually consistent instead of allowing their
# respective dependencies to choose different defaults.
.palette_space <- "Lab"


#' Convert HEX Colors to RGB
#'
#' Convert a character vector of HEX color codes to a data.frame with columns
#' `hex`, `r`, `g`, `b`, and `alpha`.
#'
#' @param hex Character vector of HEX color codes (e.g. `"#FF8000"` or `"#FF8000B2"`).
#'   Both 6-digit and 8-digit (with alpha) codes are accepted. The `#` prefix
#'   is required. No NA values allowed.
#'
#' @return A data.frame with `hex` (character) and integer `r`, `g`, `b`, and
#'   `alpha` columns. Channels lie in `[0, 255]`. `alpha` is `NA_integer_` for
#'   a 6-digit input and the explicit alpha channel for an 8-digit input.
#'
#' @examples
#' hex2rgb("#FF8000")
#' hex2rgb(c("#FF8000", "#00FF00"))
#'
#' @export
hex2rgb <- function(hex) {

  # Validate inputs
  .assert_hex_colors(hex)

  hex_clean <- gsub("^#", "", hex)
  has_alpha <- nchar(hex_clean) == 8L
  alpha <- rep(NA_integer_, length(hex_clean))
  alpha[has_alpha] <- strtoi(substr(hex_clean[has_alpha], 7, 8), 16L)

  # Reason: strtoi() already returns integer, and a channel value is a whole
  # number by construction. The old as.double() wrapper only widened the type,
  # putting these columns out of step with the integer counts elsewhere
  # (list_palettes()$n_color).
  result <- data.frame(
    hex = hex,
    r   = strtoi(substr(hex_clean, 1, 2), 16L),
    g   = strtoi(substr(hex_clean, 3, 4), 16L),
    b   = strtoi(substr(hex_clean, 5, 6), 16L),
    alpha = alpha,
    stringsAsFactors = FALSE
  )

  result
}


#' Convert RGB Values to HEX Color Codes
#'
#' Convert RGB or RGBA values to HEX color codes. Accepts either a numeric
#' vector or a data.frame, symmetrically with [hex2rgb()].
#'
#' @param rgb A numeric vector of length 3 (`r`, `g`, `b`) or 4 (`r`, `g`, `b`,
#'   `alpha`), or a data.frame with `r`, `g`, `b`, and optional `alpha` columns.
#'   Matrices and arrays are not accepted. Values must lie in `[0, 255]` and
#'   are rounded to the nearest integer, with exact halves rounded up. In a
#'   data.frame, `alpha = NA` emits 6-digit HEX; a finite alpha value emits
#'   8-digit HEX. Data frames must contain at least one row; unrelated extra
#'   columns are ignored.
#'
#' @return A character vector of uppercase 6- or 8-digit HEX color codes.
#'
#' @examples
#' rgb2hex(c(255, 128, 0))
#' rgb2hex(c(255, 128, 0, 178))
#' rgb2hex(hex2rgb(c("#FF8000", "#00FF0080")))
#'
#' @export
rgb2hex <- function(rgb) {

  if (is.data.frame(rgb)) {
    .assert_rgb_df(rgb)
    .rgb_channels_to_hex(
      rgb$r,
      rgb$g,
      rgb$b,
      if ("alpha" %in% names(rgb)) rgb$alpha else NULL
    )
  } else {
    .assert_rgb_vector(rgb)
    .rgb_channels_to_hex(
      rgb[1], rgb[2], rgb[3],
      if (length(rgb) == 4L) rgb[4] else NULL
    )
  }
}


#' Convert separate RGB(A) channels to HEX
#'
#' @param r,g,b Numeric vectors of equal length.
#' @param alpha Optional numeric vector of equal length. `NA` omits alpha for
#'   that element.
#' @return Character vector of 6- or 8-digit HEX codes.
#'
#' @keywords internal
#' @noRd
.rgb_channels_to_hex <- function(r, g, b, alpha = NULL) {
  round_channel <- function(x) floor(x + 0.5)

  result <- grDevices::rgb(
    round_channel(r), round_channel(g), round_channel(b),
    maxColorValue = 255
  )

  if (is.null(alpha)) return(toupper(unname(result)))

  has_alpha <- !is.na(alpha)
  if (any(has_alpha)) {
    result[has_alpha] <- grDevices::rgb(
      round_channel(r[has_alpha]),
      round_channel(g[has_alpha]),
      round_channel(b[has_alpha]),
      alpha = round_channel(alpha[has_alpha]),
      maxColorValue = 255
    )
  }

  toupper(unname(result))
}


#' Resample a ramp of colors to n steps
#'
#' Spans the whole ramp rather than taking a prefix of it, so a 6-stop
#' sequential palette asked for 3 colors returns light-mid-dark, not the three
#' lightest stops. Interpolation uses the same Lab-space palette function as
#' the package's ggplot2 gradients.
#'
#' @param colors Character vector of HEX color codes (the ramp stops).
#' @param n Integer. Number of steps to return. May exceed `length(colors)`.
#' @return Character vector of `n` HEX color codes.
#'
#' @keywords internal
#' @noRd
.ramp_colors <- function(colors, n) {
  positions <- seq(0, 1, length.out = n)
  scales::gradient_n_pal(colors, space = .palette_space)(positions)
}
