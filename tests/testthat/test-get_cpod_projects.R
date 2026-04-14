test_that("get_cpod_projects() returns a tibble", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  df <- get_cpod_projects()

  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_cpod_projects() returns unique project_id", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  df <- get_cpod_projects()
  expect_identical(nrow(df), nrow(df |> dplyr::distinct(project_id)))
})

test_that("get_cpod_projects() returns the expected columns", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  expected_col_names <- c(
    "project_id",
    "project_code",
    "project_type",
    "telemetry_type",
    "project_name",
    "start_date",
    "end_date",
    "latitude",
    "longitude",
    "moratorium",
    "imis_dataset_id"
  )

  df <- get_cpod_projects()

  expect_identical(names(df), expected_col_names)
})

test_that("get_cpod_projects() allows selecting on cpod_project_code", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

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
    single_select_df |> dplyr::distinct(project_code) |> dplyr::pull(),
    c(single_select)
  )
  expect_identical(nrow(single_select_df), 1L)

  # Selection is case insensitive
  expect_equal(
    get_cpod_projects(cpod_project_code = "cpod-lifewatch"),
    get_cpod_projects(cpod_project_code = "CPOD-LIFEWATCH")
  )

  # Select multiple values
  multi_select <- c("cpod-lifewatch", "cpod-od-natuur")
  multi_select_df <- get_cpod_projects(cpod_project_code = multi_select)
  expect_equal(
    multi_select_df |> dplyr::distinct(project_code) |> dplyr::pull() |> sort(),
    c(multi_select)
  )
  expect_identical(nrow(multi_select_df), 2L)
})

test_that("get_cpod_projects() returns projects of type 'cpod'", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  expect_equal(
    get_cpod_projects() |> dplyr::distinct(project_type) |> dplyr::pull(),
    "cpod"
  )
})

test_that("get_cpod_projects() returns citation information when requested", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")
  skip_if_offline("marineinfo.org")

  cpod_project_codes <- c(
    "Apelafico_underwater",
    "cpod-lifewatch",
    "SEAWave"
  )

  citation_columns <- c(
    "imis_dataset_id", # To make fetching citations possible
    "citation",
    "doi",
    "contact_name",
    "contact_email",
    "contact_affiliation"
  )

  expect_contains(
    names(
      get_cpod_projects(
        cpod_project_code = cpod_project_codes,
        citation = TRUE
      )
    ),
    citation_columns
  )
})
