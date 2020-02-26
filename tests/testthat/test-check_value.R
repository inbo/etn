con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

valid_animal_projects <- list_animal_project_codes(con)

testthat::test_that("Test input for project_type", {
  expect_error(
    check_value("not_a_project_type", c("animal", "network"), "project_type"),
    paste0(
      "Invalid value(s) for project_type argument.",
      "\nValid inputs are: animal and network."
    ),
    fixed = TRUE
  )
  expect_error(
    check_value(c("animal", "not_a_project_type"), c("animal", "network"), "project_type"),
    paste0(
      "Invalid value(s) for project_type argument.",
      "\nValid inputs are: animal and network."
    ),
    fixed = TRUE
  )
  expect_true(
    check_value("animal", c("animal", "network"), "project_type")
  )
  expect_true(
    check_value(NULL, c("animal", "network"), "project_type")
  )
  expect_true(
    check_value(c("animal", "network"), c("animal", "network"), "project_type")
  )
})

testthat::test_that("Test input for animal_project", {
  expect_error(
    check_value("not_an_animal_project", valid_animal_projects, "animal_project")
  )
  expect_true(
    check_value("2011_rivierprik", valid_animal_projects, "animal_project")
  )
  expect_true(
    check_value(c("2012_leopoldkanaal", "phd_reubens"), valid_animal_projects, "animal_project")
  )
  expect_error(
    check_value(c("2012_leopoldkanaal", "not_an_animal_project"), valid_animal_projects, "animal_project")
  )
  expect_true(
    check_value(NULL, valid_animal_projects, "animal_project")
  )
})
