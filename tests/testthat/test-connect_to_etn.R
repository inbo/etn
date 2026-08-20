test_that("connect_to_etn() returns deprecation warning when used with named
           arguments", {
  lifecycle::expect_deprecated(
    connect_to_etn(username = "my name", password = "my password")
  )
})

test_that("connect_to_etn() returns NULL invisibly", {
  # connect_to_etn() is hard deprecated and no longer used
  # It should return NULL rather than connection information
  expect_null(suppressWarnings(connect_to_etn()))
})
