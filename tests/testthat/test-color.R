#===============================================================================
# Test: hex2rgb() and rgb2hex() colour conversion
#===============================================================================

test_that("hex2rgb() converts HEX to integer RGBA channels", {
  result <- hex2rgb("#FF8000")
  expect_named(result, c("hex", "r", "g", "b", "alpha"))
  expect_identical(result$hex, "#FF8000")
  expect_identical(result$r, 255L)
  expect_identical(result$g, 128L)
  expect_identical(result$b, 0L)
  expect_identical(result$alpha, NA_integer_)
})

test_that("hex2rgb() returns stable channel types", {
  result <- hex2rgb(c("#FF8000", "#00FF0080"))
  expect_type(result$hex, "character")
  for (channel in c("r", "g", "b", "alpha")) {
    expect_type(result[[channel]], "integer")
  }
})

test_that("hex2rgb() converts colors and preserves explicit alpha", {
  result <- hex2rgb(c("#FF0000", "#00FF0080", "#0000FFFF", "#11223300"))
  expect_identical(result$r, c(255L, 0L, 0L, 17L))
  expect_identical(result$g, c(0L, 255L, 0L, 34L))
  expect_identical(result$b, c(0L, 0L, 255L, 51L))
  expect_identical(result$alpha, c(NA_integer_, 128L, 255L, 0L))
})

test_that("hex2rgb() distinguishes absent and explicit opaque alpha", {
  result <- hex2rgb(c("#FF8000", "#FF8000FF"))
  expect_identical(result$alpha, c(NA_integer_, 255L))
})

test_that("hex2rgb() is case-insensitive", {
  upper <- hex2rgb("#AABBCCDD")
  lower <- hex2rgb("#aabbccdd")
  mixed <- hex2rgb("#AaBbCcDd")
  columns <- c("r", "g", "b", "alpha")
  expect_identical(upper[columns], lower[columns])
  expect_identical(upper[columns], mixed[columns])
})

test_that("hex2rgb() validates HEX input", {
  expect_error(hex2rgb("FF8000"), "invalid HEX codes")
  expect_error(hex2rgb("FF8000B2"), "invalid HEX codes")
  expect_error(hex2rgb("#GGGGGG"), "invalid HEX codes")
  expect_error(hex2rgb("#FFF"), "invalid HEX codes")
  expect_error(hex2rgb("#FF800"), "invalid HEX codes")
  expect_error(hex2rgb(NA_character_), "invalid HEX codes")
  expect_error(hex2rgb(123), "non-empty character vector")
  expect_error(hex2rgb(NULL), "non-empty character vector")
  expect_error(hex2rgb(character(0)), "non-empty character vector")
})

test_that("rgb2hex() converts numeric RGB and RGBA vectors", {
  expect_identical(rgb2hex(c(255, 128, 0)), "#FF8000")
  expect_identical(rgb2hex(c(255, 128, 0, 178)), "#FF8000B2")
  expect_identical(rgb2hex(c(0, 0, 0, 0)), "#00000000")
  expect_identical(rgb2hex(c(255, 255, 255, 255)), "#FFFFFFFF")
})

test_that("rgb2hex() rounds every channel", {
  expect_identical(rgb2hex(c(254.6, 127.4, 0.5)), "#FF7F01")
  expect_identical(rgb2hex(c(254.6, 127.4, 0.5, 127.5)), "#FF7F0180")
})

test_that("rgb2hex() normalizes output to uppercase", {
  rgb <- hex2rgb(c("#aabbcc", "#112233dd"))
  expect_identical(rgb2hex(rgb), c("#AABBCC", "#112233DD"))
})

test_that("rgb2hex() accepts data.frame input without alpha", {
  rgb <- data.frame(r = c(255, 0), g = c(0, 255), b = c(0, 0))
  expect_identical(rgb2hex(rgb), c("#FF0000", "#00FF00"))
})

test_that("rgb2hex() handles optional and mixed data.frame alpha", {
  rgb <- data.frame(
    r = c(255, 0, 17), g = c(128, 255, 34), b = c(0, 0, 51),
    alpha = c(NA, 128, 0)
  )
  expect_identical(rgb2hex(rgb), c("#FF8000", "#00FF0080", "#11223300"))
})

test_that("HEX conversion is lossless for mixed 6- and 8-digit input", {
  original <- c("#E64B35", "#4DBBD580", "#00A087FF", "#11223300")
  expect_identical(rgb2hex(hex2rgb(original)), original)
})

test_that("rgb2hex() validates numeric vectors", {
  expect_error(rgb2hex(c(-1, 0, 0)), "values must be in \\[0, 255\\]")
  expect_error(rgb2hex(c(0, 256, 0)), "values must be in \\[0, 255\\]")
  expect_error(rgb2hex(c(0, 0, 0, 256)), "values must be in \\[0, 255\\]")
  expect_error(rgb2hex(c(1, 2)), "numeric vector of length 3 or 4")
  expect_error(rgb2hex(c(1, 2, 3, 4, 5)), "numeric vector of length 3 or 4")
  expect_error(rgb2hex(c(NA, 0, 0)), "NA, Inf, or NaN")
  expect_error(rgb2hex(c(Inf, 0, 0)), "NA, Inf, or NaN")
  expect_error(rgb2hex(matrix(c(1, 2, 3), nrow = 1)), "numeric vector")
  expect_error(rgb2hex(array(c(1, 2, 3), dim = c(1, 1, 3))), "numeric vector")
})

test_that("rgb2hex() validates data.frame channels", {
  expect_error(
    rgb2hex(data.frame(r = numeric(), g = numeric(), b = numeric())),
    "at least one row"
  )
  expect_error(rgb2hex(data.frame(r = 255, g = 0)), "Missing")
  expect_error(rgb2hex(data.frame(r = 300, g = 0, b = 0)), "values in \\[0, 255\\]")
  expect_error(
    rgb2hex(data.frame(r = 0, g = 0, b = 0, alpha = Inf)),
    "alpha.*NA or numeric values"
  )
  expect_error(
    rgb2hex(data.frame(r = 0, g = 0, b = 0, alpha = "opaque")),
    "alpha.*NA or numeric values"
  )
})

test_that("rgb2hex() accepts all-NA alpha and ignores unrelated columns", {
  rgb <- data.frame(
    r = c(17, 68), g = c(34, 85), b = c(51, 102),
    alpha = c(NA, NA), label = c("first", "second")
  )
  expect_identical(rgb2hex(rgb), c("#112233", "#445566"))
})

#===============================================================================
# End: test-color.R
#===============================================================================
