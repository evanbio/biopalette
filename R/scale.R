# =============================================================================
# scale.R — ggplot2 scales backed by biopalette collections
# =============================================================================


#' Discrete ggplot2 Scales from a biopalette Palette
#'
#' Use a named biopalette palette for a discrete colour or fill mapping. The
#' scale asks [get_palette()] for exactly as many colours as the trained data
#' has levels. Qualitative palettes therefore use their first `n` colours,
#' while sequential and diverging palettes sample `n` colours across their
#' complete ramps.
#'
#' All three palette types are supported. Qualitative palettes suit unordered
#' categories; sequential and diverging palettes can be useful for ordered
#' categories.
#'
#' @param palette Character. Name of the palette.
#' @param ... Passed to [ggplot2::discrete_scale()], for example `name`,
#'   `breaks`, `labels`, `limits`, `na.value`, `drop`, and `guide`.
#' @param type Character. One of `"sequential"`, `"diverging"`, or
#'   `"qualitative"`. If `NULL`, the type is detected automatically.
#' @param reverse Logical. Reverse the palette. Default: `FALSE`.
#' @param palettes_dir Character. Directory holding a palette collection. If
#'   `NULL`, the palettes bundled with the package are used.
#'
#' @return A ggplot2 discrete scale.
#'
#' @examples
#' library(ggplot2)
#'
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, colour = Species)) +
#'   geom_point() +
#'   scale_color_biopalette("three_body")
#'
#' ggplot(iris, aes(Species, Sepal.Length, fill = Species)) +
#'   geom_boxplot() +
#'   scale_fill_biopalette("three_body", guide = "none")
#'
#' @export
scale_color_biopalette <- function(palette,
                                   ...,
                                   type = NULL,
                                   reverse = FALSE,
                                   palettes_dir = NULL) {
  .biopalette_discrete_scale(
    aesthetics = "colour",
    palette = palette,
    type = type,
    reverse = reverse,
    palettes_dir = palettes_dir,
    ...
  )
}


#' @rdname scale_color_biopalette
#' @export
scale_colour_biopalette <- scale_color_biopalette


#' @rdname scale_color_biopalette
#' @export
scale_fill_biopalette <- function(palette,
                                  ...,
                                  type = NULL,
                                  reverse = FALSE,
                                  palettes_dir = NULL) {
  .biopalette_discrete_scale(
    aesthetics = "fill",
    palette = palette,
    type = type,
    reverse = reverse,
    palettes_dir = palettes_dir,
    ...
  )
}


#' Continuous ggplot2 Gradients from a biopalette Palette
#'
#' Build a continuous colour or fill gradient from a sequential or diverging
#' biopalette palette. The complete palette supplies the gradient stops to
#' [ggplot2::scale_colour_gradientn()] or [ggplot2::scale_fill_gradientn()].
#' Gradients are interpolated in Lab colour space, the same space used when
#' [get_palette()] resamples sequential and diverging palettes.
#'
#' Qualitative palettes are rejected because interpolating unordered category
#' colours does not produce a meaningful continuous scale. Use
#' [scale_color_biopalette()] or [scale_fill_biopalette()] for those palettes.
#'
#' @param palette Character. Name of the palette.
#' @param ... Passed to [ggplot2::scale_colour_gradientn()] or
#'   [ggplot2::scale_fill_gradientn()], for example `name`, `breaks`, `labels`,
#'   `limits`, `transform`, `na.value`, and `guide`.
#' @param type Character. `"sequential"` or `"diverging"`. If `NULL`, the
#'   type is detected automatically.
#' @param reverse Logical. Reverse the palette. When `values` is supplied, its
#'   spacing is reversed with the colours. Default: `FALSE`.
#' @param values Optional numeric positions for the palette colours, as accepted
#'   by [ggplot2::scale_colour_gradientn()]. Must have one value per palette
#'   colour, be non-decreasing, and lie in `[0, 1]`.
#' @param midpoint Optional finite numeric value to place at the visual centre
#'   of a diverging palette. Values are rescaled with equal units on either side
#'   of this point, so the shorter side of an asymmetric data range does not
#'   reach the palette's extreme colour. `midpoint` cannot be combined with
#'   `values` or a custom `rescaler`. The default, `NULL`, applies ordinary
#'   range-based scaling.
#' @param transform A transformation specification accepted by
#'   [ggplot2::continuous_scale()]. The same transformation is applied to
#'   `midpoint` before the gradient is rescaled, so the centre remains correct
#'   under transformations such as `"log10"`. Default: `"identity"`.
#' @param palettes_dir Character. Directory holding a palette collection. If
#'   `NULL`, the palettes bundled with the package are used.
#'
#' @return A ggplot2 continuous scale.
#'
#' @examples
#' library(ggplot2)
#'
#' ggplot(mtcars, aes(wt, mpg, colour = hp)) +
#'   geom_point(size = 3) +
#'   scale_color_biopalette_gradient("mitonuclear_blue")
#'
#' ggplot(mtcars, aes(factor(cyl), factor(gear), fill = mpg - mean(mpg))) +
#'   geom_tile() +
#'   scale_fill_biopalette_gradient("walter_white", midpoint = 0)
#'
#' @export
scale_color_biopalette_gradient <- function(palette,
                                            ...,
                                            type = NULL,
                                            reverse = FALSE,
                                            values = NULL,
                                            midpoint = NULL,
                                            transform = "identity",
                                            palettes_dir = NULL) {
  .biopalette_gradient_scale(
    aesthetics = "colour",
    palette = palette,
    type = type,
    reverse = reverse,
    values = values,
    midpoint = midpoint,
    transform = transform,
    palettes_dir = palettes_dir,
    ...
  )
}


#' @rdname scale_color_biopalette_gradient
#' @export
scale_colour_biopalette_gradient <- scale_color_biopalette_gradient


#' @rdname scale_color_biopalette_gradient
#' @export
scale_fill_biopalette_gradient <- function(palette,
                                           ...,
                                           type = NULL,
                                           reverse = FALSE,
                                           values = NULL,
                                           midpoint = NULL,
                                           transform = "identity",
                                           palettes_dir = NULL) {
  .biopalette_gradient_scale(
    aesthetics = "fill",
    palette = palette,
    type = type,
    reverse = reverse,
    values = values,
    midpoint = midpoint,
    transform = transform,
    palettes_dir = palettes_dir,
    ...
  )
}


#' Build a discrete biopalette scale
#'
#' @keywords internal
#' @noRd
.biopalette_discrete_scale <- function(aesthetics, palette, type, reverse,
                                       palettes_dir, ...) {
  info <- .resolve_palette(palette, type, palettes_dir)

  palette_fun <- function(n) {
    .palette_colors(info, n = n, reverse = reverse)
  }

  dots <- list(...)
  if (!"na.value" %in% names(dots)) dots$na.value <- "grey50"

  do.call(
    ggplot2::discrete_scale,
    c(list(aesthetics = aesthetics, palette = palette_fun), dots)
  )
}


#' Build a continuous biopalette gradient scale
#'
#' @keywords internal
#' @noRd
.biopalette_gradient_scale <- function(aesthetics, palette, type, reverse,
                                       values, midpoint, transform,
                                       palettes_dir, ...) {
  info <- .resolve_palette(palette, type, palettes_dir)
  info$colors <- .palette_colors(info, reverse = reverse)

  if (identical(info$type, "qualitative")) {
    cli::cli_abort(
      c("Palette {.val {palette}} is qualitative and cannot define a continuous gradient.",
        "i" = "Use {.fn scale_color_biopalette} or {.fn scale_fill_biopalette} for a discrete mapping."),
      call = NULL
    )
  }

  if (!is.null(values)) {
    if (!is.numeric(values) || length(values) != length(info$colors) ||
        anyNA(values) || any(!is.finite(values)) ||
        any(values < 0 | values > 1) || is.unsorted(values)) {
      cli::cli_abort(
        "{.arg values} must contain one non-decreasing finite number in [0, 1] per palette colour.",
        call = NULL
      )
    }
    if (reverse) values <- 1 - rev(values)
  }

  dots <- list(...)

  if ("space" %in% names(dots) && !identical(dots$space, .palette_space)) {
    cli::cli_abort(
      "biopalette gradients use Lab colour space; {.arg space} must be {.val Lab}.",
      call = NULL
    )
  }
  dots$space <- .palette_space

  if (!is.null(midpoint)) {
    if (!is.numeric(midpoint) || length(midpoint) != 1L || is.na(midpoint) ||
        !is.finite(midpoint)) {
      cli::cli_abort("{.arg midpoint} must be a single finite number or NULL.", call = NULL)
    }
    if (!identical(info$type, "diverging")) {
      cli::cli_abort("{.arg midpoint} can only be used with a diverging palette.", call = NULL)
    }
    if (!is.null(values)) {
      cli::cli_abort("{.arg midpoint} and {.arg values} cannot be used together.", call = NULL)
    }
    if ("rescaler" %in% names(dots)) {
      cli::cli_abort("{.arg midpoint} and a custom {.arg rescaler} cannot be used together.", call = NULL)
    }

    transformation <- scales::as.transform(transform)
    transformed_midpoint <- suppressWarnings(transformation$transform(midpoint))

    if (length(transformed_midpoint) != 1L || is.na(transformed_midpoint) ||
        !is.finite(transformed_midpoint)) {
      cli::cli_abort(
        "{.arg midpoint} must be finite after {.arg transform} is applied.",
        call = NULL
      )
    }

    dots$rescaler <- function(x, to = c(0, 1), from = range(x, na.rm = TRUE)) {
      scales::rescale_mid(x, to = to, from = from, mid = transformed_midpoint)
    }
  }

  scale_fun <- if (identical(aesthetics, "colour")) {
    ggplot2::scale_colour_gradientn
  } else {
    ggplot2::scale_fill_gradientn
  }

  do.call(
    scale_fun,
    c(list(colours = info$colors, values = values, transform = transform), dots)
  )
}
