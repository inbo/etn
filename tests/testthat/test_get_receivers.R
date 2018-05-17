context("test_get_receivers")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test1 <- get_receivers(con)
test2 <- get_receivers(con, network_project = "thornton")
test3 <- get_receivers(con, network_project = c("thornton", "leopold"))

testthat::test_that("test_input_get_receivers", {
  expect_error(get_receivers("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_receivers(con, network_project = "very_bad_project"))
  expect_error(get_receivers(con, network_project = c("thornton",
                                                      "very_bad_project")))
})

testthat::test_that("test_output_get_receivers", {
  expect_is(test1, "data.frame")
  expect_is(test2, "data.frame")
  expect_is(test3, "data.frame")
  expect_gte(nrow(test1), nrow(test2))
  expect_gte(nrow(test1), nrow(test3))
  expect_gte(nrow(test3), nrow(test2))
  expect_equal(ncol(test1), ncol(test2))
  expect_equal(ncol(test2), ncol(test3))
})

