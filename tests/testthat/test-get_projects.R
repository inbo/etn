con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names <- c(
  "pk",
  "project_code",
  "project_type",
  "application_type",
  "telemetry_type",
  "project_name",
  "principal_investigator_email",
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
projects_cpod <- get_projects(con, application_type = "cpod")

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
    get_projects(con, application_type = "not_an_application_type")
  )
})

testthat::test_that("Test output type", {
  expect_is(projects_all, "tbl_df")
  expect_is(projects_animal, "tbl_df")
  expect_is(projects_network, "tbl_df")
  expect_is(projects_cpod, "tbl_df")
})

testthat::test_that("Test column names", {
  expect_equal(names(projects_all), expected_col_names)
  expect_equal(names(projects_animal), expected_col_names)
  expect_equal(names(projects_network), expected_col_names)
  expect_equal(names(projects_cpod), expected_col_names)
})

testthat::test_that("Test number of records", {
  expect_gt(nrow(projects_all), nrow(projects_animal))
  expect_gt(nrow(projects_all), nrow(projects_network))
  expect_equal(nrow(projects_all), nrow(projects_network) + nrow(projects_animal))
  expect_gt(nrow(projects_all), nrow(projects_cpod))
})

testthat::test_that("Test if data is filtered on parameter", {
  expect_equal(
    projects_animal %>% distinct(project_type) %>% pull(),
    c("animal")
  )
  expect_equal(
    projects_network %>% distinct(project_type) %>% pull(),
    c("network")
  )
  expect_equal(
    projects_cpod %>% distinct(application_type) %>% pull(),
    c("cpod")
  )
})

testthat::test_that("Test unique ids", {
  expect_equal(nrow(projects_all), nrow(projects_all %>% distinct(pk)))
  # expect_equal(nrow(projects_all), nrow(projects_all %>% distinct(project_code)))
})
