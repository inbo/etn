test_that("check_value() returns error for incorrect values", {
  expect_error(
    check_value("invalid", c("a", "b")),
    class = "etn_value_not_found"
  )
  expect_error(
    check_value(c("a", "invalid"), c("a", "b")),
    class = "etn_value_not_found"
  )
  expect_error(
    check_value("invalid", c("a", "b"), name = "param_name"),
    class = "etn_value_not_found"
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
    class = "etn_value_not_found"
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

test_that("check_value() can handle NA in reference", {
  expect_identical(
    check_value("A", c("A", NA, "C")),
    "A"
  )

  expect_error(
    check_value("invalid", c("A", NA, "C")),
    class = "etn_value_not_found"
  )
})

test_that("check_value() can offer a suggestion for typos", {
  expect_error(
    check_value("seeschelde", c("demer", "dijle", "zeeschelde")),
    class = "etn_value_not_found_suggest"
  )
})

test_that("check_value() offers suggestions for multiple typos", {
  expect_error(
    check_value(x = c("2000_Loire", "seeschelde"),
                y = c("2011_Loire", "zeeschelde")
    ),
    class = "etn_value_not_found_suggest"
  )
})
