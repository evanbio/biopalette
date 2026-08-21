# =============================================================================
# plot.R — Plot construction and rendering
# =============================================================================


#' Build plot and label data for one gallery page
#'
#' @param rows data.frame. Palette info (name, n) for this page.
#' @param pal_data List. All palettes for the current type.
#' @param type_val Character. Palette type name.
#' @param max_row Integer. Max colors per row.
#' @return List with `plot_data` and `label_data`.
#'
#' @keywords internal
#' @noRd
.gallery_page_data <- function(rows, pal_data, type_val, max_row) {
  y_offset <- 0
  plot_data_list  <- list()
  label_data_list <- list()

  for (i in seq_len(nrow(rows))) {
    colors   <- pal_data[[rows$name[i]]]
    n_colors <- length(colors)
    n_rows   <- ceiling(n_colors / max_row)

    for (r in seq_len(n_rows)) {
      i_start    <- (r - 1) * max_row + 1
      i_end      <- min(r * max_row, n_colors)
      row_colors <- colors[i_start:i_end]

      plot_data_list[[length(plot_data_list) + 1]] <- data.frame(
        type  = type_val,
        name  = rows$name[i],
        x     = seq_along(row_colors) * 2,
        y     = y_offset,
        color = row_colors,
        stringsAsFactors = FALSE
      )

      label_data_list[[length(label_data_list) + 1]] <- data.frame(
        name = rows$name[i],
        x    = 0.8,
        y    = y_offset,
        stringsAsFactors = FALSE
      )

      y_offset <- y_offset - 1.5
    }
    y_offset <- y_offset - 0.5
  }

  list(
    plot_data  = do.call(rbind, plot_data_list),
    label_data = do.call(rbind, label_data_list)
  )
}


#' Build a ggplot object for one gallery page
#'
#' @param plot_data data.frame. Color tile data.
#' @param label_data data.frame. Palette label data.
#' @return A ggplot object.
#'
#' @importFrom ggplot2 .data
#' @keywords internal
#' @noRd
.gallery_page_plot <- function(plot_data, label_data) {
  max_x <- max(plot_data$x)

  ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$x, y = .data$y, fill = .data$color)) +
    ggplot2::geom_tile(width = 1.8, height = 0.7) +
    ggplot2::geom_text(
      data = label_data,
      ggplot2::aes(x = .data$x, y = .data$y, label = .data$name),
      hjust = 1, size = 3.6, inherit.aes = FALSE
    ) +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_x_continuous(expand = c(0, 0)) +
    ggplot2::coord_fixed(xlim = c(-2, max_x + 2), clip = "off") +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(20, 20, 20, 20))
}


#' Build the ggplot object for the "rect" preview
#'
#' Split out from `.preview_draw()` because it is the one preview that
#' draws through ggplot2/grid rather than base graphics. Keeping it separate
#' makes that split visible instead of burying it in a `switch()` arm.
#'
#' @param colors Character vector of HEX color codes.
#' @param title Character. Plot title.
#' @return A ggplot object.
#'
#' @importFrom ggplot2 .data
#' @keywords internal
#' @noRd
.preview_plot_rect <- function(colors, title) {
  num_colors <- length(colors)
  n_slots    <- max(num_colors, 12L)
  xs         <- .tile_x(num_colors, n_slots)
  title_x    <- mean(xs)   # center title over the tiles
  df <- data.frame(x = xs, color = colors, stringsAsFactors = FALSE)

  ggplot2::ggplot(df) +
    ggplot2::annotate(
      "text", x = title_x, y = 0.92, label = title,
      color = "#000000", size = 4.2, hjust = 0.5, vjust = 1
    ) +
    ggplot2::geom_tile(
      ggplot2::aes(x = .data$x, y = 0.5, fill = .data$color),
      width = 1.0, height = 0.55, color = NA
    ) +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_x_continuous(limits = c(0, n_slots), expand = c(0, 0)) +
    ggplot2::scale_y_continuous(limits = c(0, 1)) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(8, 12, 8, 12))
}


#' Render a palette preview plot
#'
#' Draws to the active device and returns nothing. Four of the five styles are
#' base graphics; "rect" goes through ggplot2.
#'
#' @param colors Character vector of HEX color codes.
#' @param plot_type Character. One of "bar", "pie", "point", "rect", "circle".
#' @param title Character. Plot title.
#' @return `NULL`, invisibly.
#'
#' @importFrom graphics par
#' @keywords internal
#' @noRd
.preview_draw <- function(colors, plot_type, title) {

  # Reason: par() governs base graphics only. "rect" draws through ggplot2 /
  # grid, which ignores these settings, so setting and restoring them around
  # that branch was pure noise on a device grid had already taken over.
  if (plot_type == "rect") {
    print(.preview_plot_rect(colors, title))
    return(invisible(NULL))
  }

  opar <- par(mai = c(0.15, 0.1, 0.35, 0.1))
  on.exit(par(opar), add = TRUE)
  num_colors <- length(colors)

  switch(plot_type,
    "bar" = {
      graphics::barplot(rep(1, num_colors), col = colors, border = NA, space = 0,
        axes = FALSE, main = title, names.arg = colors, las = 2, cex.names = 0.8)
    },
    "pie" = {
      graphics::pie(rep(1, num_colors), col = colors, labels = colors, border = "white",
        main = title, cex = 0.8)
    },
    "point" = {
      graphics::plot(seq_len(num_colors), rep(1, num_colors), pch = 19, cex = 5, col = colors,
        axes = FALSE, xlab = "", ylab = "", main = title)
      graphics::text(seq_len(num_colors), rep(1.2, num_colors), labels = colors, pos = 3, cex = 0.8)
    },
    "circle" = {
      graphics::plot(0, 0, type = "n", xlim = c(0, num_colors), ylim = c(0, 1),
        axes = FALSE, xlab = "", ylab = "", main = title)
      graphics::symbols(seq_len(num_colors) - 0.5, rep(0.5, num_colors), circles = rep(0.4, num_colors),
        inches = FALSE, bg = colors, add = TRUE)
      graphics::text(seq_len(num_colors) - 0.5, 0.5, labels = colors, col = "white", cex = 0.8)
    }
  )

  invisible(NULL)
}


#' Compute centered x positions for palette tiles
#'
#' Given n_colors tiles in a fixed n_slots grid, returns x midpoints
#' so the tiles are centered with equal white space on both sides.
#'
#' @param n_colors Integer. Number of color tiles.
#' @param n_slots  Integer. Total slots in the grid (>= n_colors).
#' @return Numeric vector of x midpoints, length n_colors.
#'
#' @keywords internal
#' @noRd
.tile_x <- function(n_colors, n_slots) {
  n_slots  <- max(n_slots, n_colors)
  offset   <- (n_slots - n_colors) / 2
  offset + seq_len(n_colors) - 0.5
}
