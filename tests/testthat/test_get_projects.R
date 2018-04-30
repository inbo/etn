context("check_get_projects")

# Valid connection
con <- connect_to_etn(username, password)

testthat::test_that("check_input_connection", {
  expect_error(get_projects("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_projects(con, project_type = "bad_project_type"),
               paste("Not valid input value(s) for project_type input",
                     "argument.\nValid inputs are: animal and network."),
               fixed = TRUE)
  expect_error(get_projects(con, prj_type = "bad_project_type"),
               "unused argument (prj_type = \"bad_project_type\")")
})

testthat::test_that("check_output_connection", {
  prjcts <- get_projects(con)
  expect_is(prjcts, "data.frame")
  prjcts_animal <- get_projects(con, project_type = "animal")
})
