context("test_get_transmitters")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test1 <- get_transmitters(con)
test2 <- get_transmitters(con, animal_project = "phd_reubens")
test3 <- get_transmitters(con, animal_project = c("phd_reubens",
                                                  "2012_leopoldkanaal"))
test4 <- get_transmitters(con,
                          animal_project = "phd_reubens",
                          include_reference_tags = TRUE)

testthat::test_that("test_input_get_transmitters", {
  expect_error(get_transmitters("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_transmitters(con, animal_project = "very_bad_project"))
  expect_error(get_transmitters(con, animal_project = c("phd_reubens",
                                                        "very_bad_project")))
  expect_error(get_transmitters(con, include_reference_tags = "not logical"))
})

testthat::test_that("test_output_get_transmitters", {
  expect_is(test1, "data.frame")
  expect_is(test2, "data.frame")
  expect_is(test3, "data.frame")
  expect_is(test4, "data.frame")
  expect_gte(nrow(test1), nrow(test2))
  expect_gte(nrow(test1), nrow(test3))
  expect_gte(nrow(test3), nrow(test2))
  expect_gte(nrow(test4), nrow(test2))
  expect_equal(ncol(test1), ncol(test2))
  expect_equal(ncol(test1), ncol(test3))
  expect_equal(ncol(test3), ncol(test2))
  expect_equal(ncol(test4), ncol(test2))
  expect_equal(test2 %>%
                 distinct(acoustic_tag_type) %>%
                 pull(), c("sentinel","animal"))
})
