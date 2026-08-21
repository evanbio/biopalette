# =============================================================================
# test-scale.R — ggplot2 scales backed by biopalette palettes
# =============================================================================


drawn_aesthetic <- function(plot, aesthetic) {
  built <- ggplot2::ggplot_build(plot)
  built$data[[1]][[aesthetic]]
}


test_that("discrete colour and fill scales use the selected palette", {
  colour_plot <- ggplot2::ggplot(
    iris,
    ggplot2::aes(Sepal.Length, Sepal.Width, colour = Species)
  ) +
    ggplot2::geom_point() +
    scale_color_biopalette("three_body")

  fill_plot <- ggplot2::ggplot(
    iris,
    ggplot2::aes(Species, Sepal.Length, fill = Species)
  ) +
    ggplot2::geom_col() +
    scale_fill_biopalette("three_body")

  expected <- get_palette("three_body")
  expect_identical(unique(drawn_aesthetic(colour_plot, "colour")), expected)
  expect_identical(unique(drawn_aesthetic(fill_plot, "fill")), expected)
})


test_that("colour spelling is a strict alias", {
  expect_identical(scale_colour_biopalette, scale_color_biopalette)
  expect_identical(
    scale_colour_biopalette_gradient,
    scale_color_biopalette_gradient
  )
})


test_that("discrete ramp palettes span the whole ramp and respect reverse", {
  df <- data.frame(x = 1:3, group = factor(letters[1:3]))
  plot <- ggplot2::ggplot(df, ggplot2::aes(x, x, colour = group)) +
    ggplot2::geom_point() +
    scale_color_biopalette("mitonuclear_blue", reverse = TRUE)

  expected <- get_palette("mitonuclear_blue", n = 3, reverse = TRUE)
  expect_identical(unique(drawn_aesthetic(plot, "colour")), expected)

  diverging_plot <- ggplot2::ggplot(df, ggplot2::aes(x, x, fill = group)) +
    ggplot2::geom_tile() +
    scale_fill_biopalette("walter_white")

  expect_identical(
    unique(drawn_aesthetic(diverging_plot, "fill")),
    get_palette("walter_white", n = 3)
  )
})


test_that("discrete scale arguments pass through to ggplot2", {
  scale <- scale_color_biopalette(
    "three_body",
    name = "Cell type",
    limits = c("setosa", "versicolor", "virginica"),
    na.value = "grey80"
  )

  expect_identical(scale$name, "Cell type")
  expect_identical(scale$na.value, "grey80")
  expect_identical(scale$get_limits(), c("setosa", "versicolor", "virginica"))
})


test_that("qualitative discrete scales fail when levels exceed the palette", {
  df <- data.frame(x = 1:3, group = factor(letters[1:3]))
  plot <- ggplot2::ggplot(df, ggplot2::aes(x, x, colour = group)) +
    ggplot2::geom_point() +
    scale_color_biopalette("gene_red")

  expect_error(
    ggplot2::ggplot_build(plot),
    "only has.*2.*colors.*3.*requested"
  )
})


test_that("gradient colour and fill scales map the palette endpoints", {
  df <- data.frame(x = 1:2, value = c(0, 1))
  colors <- get_palette("mitonuclear_blue")

  colour_plot <- ggplot2::ggplot(df, ggplot2::aes(x, x, colour = value)) +
    ggplot2::geom_point() +
    scale_color_biopalette_gradient("mitonuclear_blue")

  fill_plot <- ggplot2::ggplot(df, ggplot2::aes(x, 1, fill = value)) +
    ggplot2::geom_tile() +
    scale_fill_biopalette_gradient("mitonuclear_blue")

  expect_identical(drawn_aesthetic(colour_plot, "colour"), colors[c(1, length(colors))])
  expect_identical(drawn_aesthetic(fill_plot, "fill"), colors[c(1, length(colors))])
})


test_that("get_palette() and gradient scales share Lab interpolation", {
  n <- 11L
  scale <- scale_color_biopalette_gradient("mitonuclear_blue")

  expect_identical(
    get_palette("mitonuclear_blue", n = n),
    scale$palette(seq(0, 1, length.out = n))
  )
})


test_that("gradient interpolation space is fixed to Lab", {
  expect_no_error(
    scale_color_biopalette_gradient("mitonuclear_blue", space = "Lab")
  )
  expect_error(
    scale_color_biopalette_gradient("mitonuclear_blue", space = "RGB"),
    "use Lab colour space"
  )
})


test_that("gradient scales reverse colours and non-uniform positions together", {
  values <- c(0, 0.1, 0.25, 0.5, 0.8, 1)
  scale <- scale_color_biopalette_gradient(
    "mitonuclear_blue",
    reverse = TRUE,
    values = values
  )

  expect_identical(scale$palette(c(0, 1)), rev(get_palette("mitonuclear_blue"))[c(1, 6)])
})


test_that("qualitative palettes cannot define a continuous gradient", {
  expect_error(
    scale_color_biopalette_gradient("three_body"),
    "qualitative and cannot define a continuous gradient"
  )
  expect_error(
    scale_fill_biopalette_gradient("babel"),
    "qualitative and cannot define a continuous gradient"
  )
})


test_that("midpoint centres a diverging gradient", {
  scale <- scale_color_biopalette_gradient("walter_white", midpoint = 0)

  # rescale_mid() uses equal units on both sides of the midpoint. With an
  # asymmetric range, the shorter side therefore does not reach the palette's
  # extreme colour.
  expect_equal(
    scale$rescaler(c(-2, 0, 6), from = c(-2, 6)),
    c(1 / 3, 0.5, 1)
  )
})


test_that("midpoint is transformed into the scale's coordinate space", {
  scale <- scale_color_biopalette_gradient(
    "walter_white",
    midpoint = 10,
    transform = "log10"
  )

  # ggplot2 trains and rescales continuous values after transformation. The
  # raw midpoint 10 must therefore become 1 before it reaches the rescaler.
  expect_equal(
    scale$rescaler(c(-1, 1, 3), from = c(-1, 3)),
    c(0, 0.5, 1)
  )
  expect_identical(scale$trans$name, "log-10")
})


test_that("midpoint has a narrow and explicit contract", {
  expect_error(
    scale_color_biopalette_gradient("mitonuclear_blue", midpoint = 0),
    "only be used with a diverging palette"
  )
  expect_error(
    scale_color_biopalette_gradient("walter_white", midpoint = Inf),
    "single finite number"
  )
  expect_error(
    scale_color_biopalette_gradient(
      "walter_white",
      midpoint = 0,
      transform = "log10"
    ),
    "finite after.*transform"
  )
  expect_error(
    scale_color_biopalette_gradient("walter_white", midpoint = 0, values = seq(0, 1, length.out = 5)),
    "cannot be used together"
  )
  expect_error(
    scale_color_biopalette_gradient(
      "walter_white",
      midpoint = 0,
      rescaler = scales::rescale
    ),
    "custom.*rescaler"
  )
})


test_that("gradient values are validated", {
  expect_error(
    scale_color_biopalette_gradient("mitonuclear_blue", values = c(0, 1)),
    "one non-decreasing"
  )
  expect_error(
    scale_color_biopalette_gradient("mitonuclear_blue", values = c(0, 0.2, 0.4, 0.8, 0.7, 1)),
    "one non-decreasing"
  )
  expect_error(
    scale_color_biopalette_gradient("mitonuclear_blue", values = c(0, 0.2, 0.4, 0.6, 0.8, 2)),
    "one non-decreasing"
  )
})


test_that("scale functions support explicit custom collections", {
  root <- file.path(tempdir(), paste0("scale_collection_", Sys.getpid()))
  on.exit(unlink(root, recursive = TRUE), add = TRUE)

  suppressMessages(create_palette(
    "custom_gradient",
    "sequential",
    c("#000000", "#FFFFFF"),
    palettes_dir = root
  ))

  expect_s3_class(
    scale_color_biopalette("custom_gradient", palettes_dir = root),
    "ScaleDiscrete"
  )
  expect_s3_class(
    scale_color_biopalette_gradient("custom_gradient", palettes_dir = root),
    "ScaleContinuous"
  )
})
