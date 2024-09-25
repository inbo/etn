test_that("connect_to_etn() returns NULL since it's deprecation", {
  # This is intended to be a hard deprecated function, that is no longer used.
  # For local connections to the ETN database, use the non exported
  # create_connection() function instead.
  expect_null(suppressWarnings(connect_to_etn()))
})

test_that("connect_to_etn() returns deprecation warning when used", {
  expect_warning(connect_to_etn(),
    regexp =
      "was deprecated in etn 2.3.0."
    )
  expect_warning(connect_to_etn(),
                 regexp =
                   "You will be prompted for credentials instead."
  )
})
