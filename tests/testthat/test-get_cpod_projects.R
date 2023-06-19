# con <- connect_to_etn()
#
# test_that("get_cpod_projects() returns error for incorrect connection", {
#   expect_error(
#     get_cpod_projects(con = "not_a_connection"),
#     "Not a connection object to database."
#   )
# })
df <- get_cpod_projects()
df_sql <- get_cpod_projects()

test_that("get_cpod_projects() returns a tibble", {
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")

  expect_s3_class(df_sql, "data.frame")
  expect_s3_class(df_sql, "tbl")
})

test_that("get_cpod_projects() returns unique project_id", {
  expect_equal(nrow(df), nrow(df %>% distinct(project_id)))
})

test_that("get_cpod_projects() returns the expected columns", {
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

test_that("get_cpod_projects() allows selecting on cpod_project_code", {
  # Errors
  expect_error(
    get_cpod_projects(cpod_project_code = "not_a_project"),
    regexp = "Can't find cpod_project_code `not_a_project` in"
    )
  expect_error(
    get_cpod_projects(cpod_project_code = c("cpod-lifewatch", "not_a_project")),
    regexp = "Can't find cpod_project_code `cpod-lifewatch` and/or `not_a_project` in"
    )

  # Select single value
  single_select <- "cpod-lifewatch"
  single_select_df <- get_cpod_projects(cpod_project_code = single_select)
  expect_equal(
    single_select_df %>% distinct(project_code) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 1)

  # Selection is case insensitive
  expect_equal(
    get_cpod_projects(cpod_project_code = "cpod-lifewatch"),
    get_cpod_projects(cpod_project_code = "CPOD-LIFEWATCH")
  )

  # Select multiple values
  multi_select <- c("cpod-lifewatch", "cpod-od-natuur")
  multi_select_df <- get_cpod_projects(cpod_project_code = multi_select)
  expect_equal(
    multi_select_df %>% distinct(project_code) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_equal(nrow(multi_select_df), 2)
})

test_that("get_cpod_projects() returns projects of type 'cpod'", {
  expect_equal(
    get_cpod_projects() %>% distinct(project_type) %>% pull(),
    "cpod"
  )
})
