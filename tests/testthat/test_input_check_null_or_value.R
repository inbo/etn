context("input_check_null_or_value")

testthat::test_that("check_null_or_value with project_type", {
  expect_error(check_null_or_value("ani",
                                   c("animal", "network"), "project_type"),
               paste0("Not valid input value(s) for project_type input argument.",
                      "\nValid inputs are: animal and network."),
               fixed = TRUE)
  expect_error(check_null_or_value(c("animal", "netw"),
                                   c("animal", "network"), "project_type"),
               paste0("Not valid input value(s) for project_type input argument.",
                      "\nValid inputs are: animal and network."),
               fixed = TRUE)
  expect_true(check_null_or_value("animal",
                                  c("animal", "network"), "project_type"))
  expect_true(check_null_or_value(NULL, c("animal", "network"), "project_type"))
  expect_true(check_null_or_value(c("animal", "network"),
                                  c("animal", "network"), "project_type"))
})

