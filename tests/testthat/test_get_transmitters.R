context("test_get_transmitters")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test1 <- get_transmitters(con)
test2 <- get_transmitters(con, animal_project = "phd_reubens")
test3 <- get_transmitters(con, animal_project = c("phd_reubens", "2012_leopoldkanaal"))

testthat::test_that("test_get_transmitters", {
  expect_error(get_transmitters("I am not a connection"),
               "Not a connection object to database.")
  expect_is(test1, "data.frame")
  expect_is(test2, "data.frame")
  expect_is(test3, "data.frame")
  expect_gte(nrow(test1), nrow(test2))
  expect_gte(nrow(test1), nrow(test3))
  expect_gte(nrow(test3), nrow(test2))
  expect_gte(ncol(test1), ncol(test2))
  expect_gte(ncol(test1), ncol(test3))
  expect_gte(ncol(test3), ncol(test2))
})
