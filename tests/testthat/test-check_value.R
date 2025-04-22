test_that("check_value() returns error for incorrect values", {
  expect_error(
    check_value("invalid", c("a", "b")),
    "Can't find value `invalid` in: a, b",
    fixed = TRUE
  )
  expect_error(
    check_value(c("a", "invalid"), c("a", "b")),
    "Can't find value `a` and/or `invalid` in: a, b",
    fixed = TRUE
  )
  expect_error(
    check_value("invalid", c("a", "b"), name = "param_name"),
    "Can't find param_name `invalid` in: a, b",
    fixed = TRUE
  )
})

test_that("check_value() returns x for correct values", {
  expect_identical(
    check_value("a", c("a", "b")),
    "a"
  )
  expect_identical(
    check_value(c("a", "b"), c("a", "b")),
    c("a", "b")
  )
})

test_that("check_value() can ignore case", {
  expect_error(
    check_value("A", c("a", "B")),
    "Can't find value `A` in: a, B",
    fixed = TRUE
  )
  expect_identical(
    check_value("A", c("a", "B"), lowercase = TRUE),
    "a"
  )
  expect_identical(
    check_value(c("A", "b"), c("a", "B"), lowercase = TRUE),
    c("a", "b")
  )
})

test_that("check_value() can handle NA in reference",{
  expect_identical(
    check_value("A", c("A",NA,"C")),
    "A"
  )

  expect_error(
    check_value("invalid", c("A",NA,"C")),
    "Can't find value `invalid` in: A, C",
    fixed = TRUE
  )
})
