test_that("connect_to_etn() returns deprecation warning when used with named arguments", {
  lifecycle::expect_deprecated(
    connect_to_etn(username = "my name", password = "my password")
  )
})

test_that("connect_to_etn() returns deprecation warning when used with unnamed arguments", {
  skip("BUG #319: tests will always fail after first deprecation test")
  lifecycle::expect_deprecated(
    connect_to_etn("my name", "my password")
  )
})

test_that("connect_to_etn() returns deprecation argument when used without arguments",{
  skip("BUG #319: tests will always fail after first deprecation test")
  lifecycle::expect_deprecated(
    connect_to_etn()
  )
})

test_that("connect_to_etn() returns NULL invisibly", {
  # connect_to_etn() is hard deprecated and no longer used
  # It should return NULL rather than connection information
  expect_null(suppressWarnings(connect_to_etn()))
})
