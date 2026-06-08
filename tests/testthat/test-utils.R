#===============================================================================
# Test: utils.R internal helpers
# File: test-utils.R
# Description: Unit tests for internal helpers used by current public APIs.
#===============================================================================

#==============================================================================
# .assert_scalar_string()
#==============================================================================

test_that(".assert_scalar_string() accepts a valid single non-empty string", {
  expect_no_error(biopalette:::.assert_scalar_string("hello"))
  expect_no_error(biopalette:::.assert_scalar_string("a"))
  expect_no_error(biopalette:::.assert_scalar_string(" space "))
})

test_that(".assert_scalar_string() returns input invisibly on success", {
  result <- biopalette:::.assert_scalar_string("ok")
  expect_equal(result, "ok")
})

test_that(".assert_scalar_string() errors on invalid input", {
  expect_error(biopalette:::.assert_scalar_string(123), "single non-empty string")
  expect_error(biopalette:::.assert_scalar_string(NULL), "single non-empty string")
  expect_error(biopalette:::.assert_scalar_string(c("a", "b")), "single non-empty string")
  expect_error(biopalette:::.assert_scalar_string(character(0)), "single non-empty string")
  expect_error(biopalette:::.assert_scalar_string(""), "single non-empty string")
  expect_error(biopalette:::.assert_scalar_string(NA_character_), "single non-empty string")
})

#==============================================================================
# .assert_dir_path()
#==============================================================================

test_that(".assert_dir_path() accepts a valid path string", {
  expect_no_error(biopalette:::.assert_dir_path("/some/path"))
  expect_no_error(biopalette:::.assert_dir_path("relative/path"))
  expect_no_error(biopalette:::.assert_dir_path(tempdir()))
})

test_that(".assert_dir_path() returns input invisibly on success", {
  result <- biopalette:::.assert_dir_path("/tmp/test")
  expect_equal(result, "/tmp/test")
})

test_that(".assert_dir_path() errors on invalid input", {
  expect_error(biopalette:::.assert_dir_path(42), "single non-empty string")
  expect_error(biopalette:::.assert_dir_path(NULL), "single non-empty string")
  expect_error(biopalette:::.assert_dir_path(""), "single non-empty string")
  expect_error(biopalette:::.assert_dir_path(c("/a", "/b")), "single non-empty string")
  expect_error(biopalette:::.assert_dir_path(NA_character_), "single non-empty string")
})

#==============================================================================
# .assert_flag()
#==============================================================================

test_that(".assert_flag() accepts TRUE and FALSE", {
  expect_no_error(biopalette:::.assert_flag(TRUE))
  expect_no_error(biopalette:::.assert_flag(FALSE))
})

test_that(".assert_flag() returns input invisibly on success", {
  expect_equal(biopalette:::.assert_flag(TRUE), TRUE)
  expect_equal(biopalette:::.assert_flag(FALSE), FALSE)
})

test_that(".assert_flag() errors on invalid input", {
  expect_error(biopalette:::.assert_flag(NA), "TRUE or FALSE")
  expect_error(biopalette:::.assert_flag(1), "TRUE or FALSE")
  expect_error(biopalette:::.assert_flag("TRUE"), "TRUE or FALSE")
  expect_error(biopalette:::.assert_flag(NULL), "TRUE or FALSE")
  expect_error(biopalette:::.assert_flag(c(TRUE, FALSE)), "TRUE or FALSE")
})

#==============================================================================
# .assert_count()
#==============================================================================

test_that(".assert_count() accepts valid positive integers", {
  expect_no_error(biopalette:::.assert_count(1))
  expect_no_error(biopalette:::.assert_count(10))
  expect_no_error(biopalette:::.assert_count(1L))
  expect_no_error(biopalette:::.assert_count(100L))
})

test_that(".assert_count() returns as.integer(x) invisibly", {
  result <- biopalette:::.assert_count(5)
  expect_equal(result, 5L)
  expect_type(result, "integer")
})

test_that(".assert_count() errors on invalid input", {
  expect_error(biopalette:::.assert_count(0), "single positive integer")
  expect_error(biopalette:::.assert_count(-1), "single positive integer")
  expect_error(biopalette:::.assert_count(1.5), "single positive integer")
  expect_error(biopalette:::.assert_count(Inf), "single positive integer")
  expect_error(biopalette:::.assert_count(NA), "single positive integer")
  expect_error(biopalette:::.assert_count("1"), "single positive integer")
  expect_error(biopalette:::.assert_count(NULL), "single positive integer")
  expect_error(biopalette:::.assert_count(c(1, 2)), "single positive integer")
})

#==============================================================================
# Integration: validate helpers work end-to-end through public API
#==============================================================================

test_that("public functions propagate core helper errors correctly", {
  expect_error(get_palette(123), "single non-empty string")
  expect_error(list_palettes(sort = "yes"), "TRUE or FALSE")
  expect_error(list_palettes(sort = NA), "TRUE or FALSE")
})

#===============================================================================
# End: test-utils.R
#===============================================================================
