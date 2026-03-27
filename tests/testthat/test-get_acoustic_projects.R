test_that("get_acoustic_projects() returns a tibble", {
  skip_if_no_authentication()

  df <- get_acoustic_projects()

  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_acoustic_projects() returns unique project_id", {
  skip_if_no_authentication()

  df <- get_acoustic_projects()
  expect_equal(nrow(df), nrow(df |> dplyr::distinct(project_id)))
})

test_that("get_acoustic_projects() returns the expected columns", {
  skip_if_no_authentication()

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

  df <- get_acoustic_projects()
  expect_identical(names(df), expected_col_names)
})

test_that("get_acoustic_projects() allows selecting on acoustic_project_code", {
  skip_if_no_authentication()

  # Errors
  expect_error(
    get_acoustic_projects(acoustic_project_code = "not_a_project"),
    regexp = "Can't find acoustic_project_code `not_a_project` in"
    )
  expect_error(
    get_acoustic_projects(acoustic_project_code = c("demer", "not_a_project")),
    regexp = "Can't find acoustic_project_code `demer` and/or `not_a_project` in"
    )

  # Select single value
  single_select <- "demer"
  single_select_df <- get_acoustic_projects(acoustic_project_code = single_select)
  expect_identical(
    single_select_df |> dplyr::distinct(project_code) |> dplyr::pull(),
    c(single_select)
  )
  expect_identical(nrow(single_select_df), 1L)

  # Selection is case insensitive
  expect_identical(
    get_acoustic_projects(acoustic_project_code = "demer"),
    get_acoustic_projects(acoustic_project_code = "DEMER")
  )

  # Select multiple values
  multi_select <- c("demer", "dijle")
  multi_select_df <- get_acoustic_projects(acoustic_project_code = multi_select)
  expect_identical(
    multi_select_df |> dplyr::distinct(project_code) |> dplyr::pull() |> sort(),
    c(multi_select)
  )
  expect_identical(nrow(multi_select_df), 2L)
})

test_that("get_acoustic_projects() returns projects of type 'acoustic'", {
  skip_if_no_authentication()

  expect_identical(
    get_acoustic_projects() |> dplyr::distinct(project_type) |> dplyr::pull(),
    "acoustic"
  )
})

test_that("get_acoustic_projects() returns citation information when requested", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")
  skip_if_offline("marineinfo.org")

  acoustic_project_codes <- c(
    "SGB",
    "ARAISOLA03",
    "Eel_migration_Test_2023",
    "rt2020_zeeschelde"
  )

  citation_columns <- c(
    "imis_dataset_id", # to make fetching citations possible
    "citation",
    "doi",
    "name",
    "email",
    "institute"
  )

  expect_contains(
    names(
      get_acoustic_projects(
        acoustic_project_code = acoustic_project_codes,
        citation = TRUE
      )
    ),
    citation_columns
  )
})
