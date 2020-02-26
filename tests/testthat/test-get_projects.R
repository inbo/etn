con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_projects <- c(
  "pk",
  "project_code",
  "project_type",
  "context_type",
  "telemetry_type",
  "project_name",
  "principal_investigator",
  "start_date",
  "end_date",
  "latitude",
  "longitude",
  "moratorium",
  "imis_dataset_id"
)

projects_all <- get_projects(con)
projects_animal <- get_projects(con, project_type = "animal")
projects_network <- get_projects(con, project_type = "network")

testthat::test_that("Test input", {
  expect_error(
    get_projects("not_a_connection"),
    "Not a connection object to database."
  )
  expect_error(
    get_projects(con, project_type = "not_a_project_type"),
    paste(
      "Invalid value(s) for project_type",
      "argument.\nValid inputs are: animal and network."
    ),
    fixed = TRUE
  )
  expect_error(
    get_projects(con, prj_type = "not_a_project_type"),
    "unused argument (prj_type = \"not_a_project_type\")",
    fixed = TRUE
  )
})

testthat::test_that("Test output type", {
  expect_is(projects_all, "data.frame")
  expect_is(projects_animal, "data.frame")
  expect_is(projects_network, "data.frame")
})

testthat::test_that("Test column names", {
  expect_true(all(names(projects_all) %in% expected_col_names_projects))
  expect_true(all(expected_col_names_projects %in% names(projects_all)))
  expect_equal(names(projects_all), names(projects_animal))
  expect_equal(names(projects_animal), names(projects_network))
})

testthat::test_that("Test number of records", {
  expect_gte(nrow(projects_all), nrow(projects_animal))
  expect_gte(nrow(projects_all), nrow(projects_network))
  expect_equal(
    nrow(projects_all),
    nrow(projects_network) + nrow(projects_animal)
  )
})

testthat::test_that("Test unique ids", {
  expect_equal(nrow(projects_all), nrow(projects_all %>% distinct(pk)))
  # expect_equal(nrow(projects_all), nrow(projects_all %>% distinct(project_code)))
})
