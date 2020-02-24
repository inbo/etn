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

testthat::test_that("test_input_get_projects", {
  expect_error(get_projects("I am not a connection"),
    "Not a connection object to database."
  )
  expect_error(get_projects(con, project_type = "bad_project_type"),
    paste(
      "Not valid input value(s) for project_type input",
      "argument.\nValid inputs are: animal and network."
    ),
    fixed = TRUE
  )
  expect_error(get_projects(con, prj_type = "bad_project_type"),
    "unused argument (prj_type = \"bad_project_type\")",
    fixed = TRUE
  )
})

testthat::test_that("test_output_get_projects", {
  # Output type
  expect_is(projects_all, "data.frame")
  expect_is(projects_animal, "data.frame")
  expect_is(projects_network, "data.frame")

  # Col names
  expect_true(all(names(projects_all) %in% expected_col_names_projects))
  expect_true(all(expected_col_names_projects %in% names(projects_all)))
  expect_equal(names(projects_all), names(projects_animal))
  expect_equal(names(projects_animal), names(projects_network))

  # Number of records
  expect_gte(nrow(projects_all), nrow(projects_animal))
  expect_gte(nrow(projects_all), nrow(projects_network))
  expect_equivalent(
    nrow(projects_all),
    nrow(projects_network) + nrow(projects_animal)
  )

  # Unique IDs
  expect_equal(nrow(projects_all), nrow(projects_all %>% distinct(pk)))
  # expect_equal(nrow(projects_all), nrow(projects_all %>% distinct(project_code)))
})
