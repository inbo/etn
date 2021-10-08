con <- connect_to_etn()

test_that("get_animal_projects() returns error for incorrect connection", {
  expect_error(
    get_animal_projects(con = "not_a_connection"),
    "Not a connection object to database."
  )
})

test_that("get_animal_projects() returns a tibble", {
  df <- get_animal_projects(con)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_animal_projects() returns unique project_id", {
  df <- get_animal_projects(con)
  expect_equal(nrow(df), nrow(df %>% distinct(project_id)))
})

test_that("get_animal_projects() returns the expected columns", {
  df <- get_animal_projects(con)
  expected_col_names <- c(
    "project_id",
    "project_code",
    "project_type",
    "telemetry_type",
    "project_name",
    # "coordinating_organization",
    # "principal_investigator",
    # "principal_investigator_email",
    "start_date",
    "end_date",
    "latitude",
    "longitude",
    "moratorium",
    "imis_dataset_id"
  )
  expect_equal(names(df), expected_col_names)
})

test_that("get_animal_projects() allows selecting on animal_project_code", {
  # Errors
  expect_error(get_animal_projects(con, animal_project_code = "not_a_project"))
  expect_error(get_animal_projects(con, animal_project_code = c("2014_demer", "not_a_project")))

  # Select single value
  single_select <- "2014_demer"
  single_select_df <- get_animal_projects(con, animal_project_code = single_select)
  expect_equal(
    single_select_df %>% distinct(project_code) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 1)

  # Selection is case insensitive
  expect_equal(
    get_animal_projects(con, animal_project_code = "2014_demer"),
    get_animal_projects(con, animal_project_code = "2014_DEMER")
  )

  # Select multiple values
  multi_select <- c("2014_demer", "2015_dijle")
  multi_select_df <- get_animal_projects(con, animal_project_code = multi_select)
  expect_equal(
    multi_select_df %>% distinct(project_code) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_equal(nrow(multi_select_df), 2)
})

test_that("get_animal_projects() returns projects of type 'animal'", {
  expect_equal(
    get_animal_projects(con) %>% distinct(project_type) %>% pull(),
    "animal"
  )
})
