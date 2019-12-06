context("test_input_null_or_value")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

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


valid_network_projects <- get_projects(connection = con,
                                       project_type = "network") %>%
  pull("projectcode")

testthat::test_that("check_null_or_value with network_type", {
  expect_error(check_null_or_value("I am not a network project",
                                   valid_network_projects,
                                   "network_project"))
  expect_true(check_null_or_value(c("thornton", "leopold"),
                                  valid_network_projects,
                                  "network_project"))
  expect_true(check_null_or_value(NULL,
                                  valid_network_projects,
                                  "network_project"))
})

valid_animal_projects <- get_projects(connection = con,
                                       project_type = "animal") %>%
  pull("projectcode")

testthat::test_that("check_null_or_value with animal_type", {
  expect_error(check_null_or_value("I am not an animal project",
                                   valid_animal_projects,
                                   "animal_project"))
  expect_true(check_null_or_value(c("2012_leopoldkanaal", "phd_reubens"),
                                  valid_animal_projects,
                                  "animal_project"))
  expect_true(check_null_or_value("2011_rivierprik",
                                  valid_animal_projects,
                                  "animal_project"))
  expect_true(check_null_or_value(NULL,
                                  valid_animal_projects,
                                  "animal_project"))
})

