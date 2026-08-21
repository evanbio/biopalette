#===============================================================================
# Test: package startup
# File: test-zzz.R
# Description: Unit tests for .onAttach() startup banner behaviour.
#===============================================================================

test_that(".onAttach() stays silent in a non-interactive session", {
  # Reason: R CMD check and CI run non-interactively; the banner must not
  # pollute their output.
  expect_silent(result <- biopalette:::.onAttach("lib", "biopalette"))
  expect_null(result)
})

test_that(".onAttach() emits both banner lines in an interactive session", {
  local_mocked_bindings(.is_interactive = function() TRUE)

  msgs <- capture_messages(biopalette:::.onAttach("lib", "biopalette"))

  expect_length(msgs, 2L)
  expect_match(msgs[1], "Welcome to biopalette")
  expect_match(msgs[1], "Version:")
  expect_match(msgs[2], "palette_gallery")
})

test_that(".onAttach() returns NULL invisibly in an interactive session", {
  local_mocked_bindings(.is_interactive = function() TRUE)

  expect_null(suppressPackageStartupMessages(
    biopalette:::.onAttach("lib", "biopalette")
  ))
})

test_that(".onAttach() banner is a startup message, so it can be suppressed", {
  local_mocked_bindings(.is_interactive = function() TRUE)

  # Reason: zzz.R routes through packageStartupMessage() precisely so that
  # suppressPackageStartupMessages() catches it. A plain message() would leak
  # past that suppressor, so this guards the choice recorded in zzz.R.
  expect_silent(
    suppressPackageStartupMessages(biopalette:::.onAttach("lib", "biopalette"))
  )
})

test_that(".is_interactive() reports the real session mode by default", {
  # Tests run non-interactively, so the unmocked seam must agree with base R.
  expect_identical(biopalette:::.is_interactive(), interactive())
})

#===============================================================================
# End: test-zzz.R
#===============================================================================
