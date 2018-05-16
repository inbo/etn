context("test_get_projects")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_input_get_projects", {
  expect_error(get_projects("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_projects(con, project_type = "bad_project_type"),
               paste("Not valid input value(s) for project_type input",
                     "argument.\nValid inputs are: animal and network."),
               fixed = TRUE)
  expect_error(get_projects(con, prj_type = "bad_project_type"),
               "unused argument (prj_type = \"bad_project_type\")",
               fixed = TRUE)
})

prjcts <- get_projects(con)
prjcts_animal <- get_projects(con, project_type = "animal")
prjcts_network <- get_projects(con, project_type = "network")

testthat::test_that("check_output_connection", {
  expect_is(prjcts, "data.frame")
  expect_is(prjcts_animal, "data.frame")
  expect_is(prjcts_network, "data.frame")
  expect_gte(nrow(prjcts), nrow(prjcts_animal))
  expect_gte(nrow(prjcts), nrow(prjcts_network))
  expect_equivalent(nrow(prjcts),
                    nrow(prjcts_network) + nrow(prjcts_animal))
})
