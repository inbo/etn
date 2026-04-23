test_that("download_acoustic_dataset() returns deprecation warning", {
  skip_if_no_authentication()
  vcr::local_cassette("dataset_demer")

  datapackage_path <- withr::local_tempdir(pattern = "2014_demer")
  lifecycle::expect_deprecated(
    download_acoustic_dataset(
      animal_project_code = "2014_demer",
      directory = datapackage_path
    )
  )
})

# Create a data package using the API
if (credentials_are_set()) {
  vcr::use_cassette( # Cache HTTP response
    "download_acoustic_dataset",
    {
      datapackage_path <- withr::local_tempdir(pattern = "2014_demer")
      evalute_download_api <- evaluate_promise({
        withr::local_options(lifecycle_verbosity = "quiet")
        with_mocked_bindings(
          {
            download_acoustic_dataset(
              animal_project_code = "2014_demer",
              directory = datapackage_path
            )
          },
          # Force an API request, otherwise vcr will fail.
          select_protocol = \(x) "opencpu"
        )
      })
    }
  )
}

# Create a data package using local database access, if available. Tests that
# require local database access should be skipped when it's not available.
if (localdb_is_available() & credentials_are_set()) {
  localdb_datapackage_path <- withr::local_tempdir(pattern = "local_2014_demer")
  evalutate_download_localdb <- evaluate_promise({
    withr::local_options(lifecycle_verbosity = "quiet")
    with_mocked_bindings(
      {
        download_acoustic_dataset(
          animal_project_code = "2014_demer",
          directory = localdb_datapackage_path
        )
      },
      # Force a query to the local database
      select_protocol = \(x) "localdb"
    )
  })
}

test_that("download_acoustic_dataset() creates the expected files using api", {
  skip_if_no_authentication()

  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "datapackage.json"
  )

  # Function creates the expected files
  expect_true(all(files_to_create %in% list.files(datapackage_path)))

})

test_that("download_acoustic_dataset() creates the expected files using local db", {
  skip_if_no_authentication()
  skip_if_not_localdb()

  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "datapackage.json"
  )

  # Function creates the expected files
  expect_true(all(files_to_create %in% list.files(localdb_datapackage_path)))
})

test_that("download_acoustic_dataset() returns the expected messages using api", {
  skip_if_no_authentication()

  expect_snapshot(
    cat(evalute_download_api$messages, sep = "\n"),
    variant = "api",
    # don't include the tempdir name
    transform = ~ stringr::str_remove(.x, pattern = "(?<=directory ).+(?=:)")
  )
})

test_that("download_acoustic_dataset() creates the expected messages using local db", {
  skip_if_not_localdb()
  skip_if_no_authentication()

  expect_snapshot(
    cat(evalutate_download_localdb$messages, sep = "\n"),
    variant = "sql",
    # don't include the tempdir name
    transform = ~ stringr::str_remove(.x, pattern = "(?<=directory ).+(?=:)")
  )

})

test_that("download_acoustic_dataset() does not return warnings for valid dataset api", {
  skip_if_no_authentication()

  # Function returns no warnings (character of length 0)
  expect_true(length(evalute_download_api$warnings) == 0)
})

test_that("download_acoustic_dataset() creates a valid Frictionless Data Package", {
  skip_if_no_authentication()

  # This will fail when a field is added to a get_ function but not to datapackage.json
  datapackage <-
    suppressMessages(read_package(file.path(datapackage_path, "datapackage.json")))
  ## Check for errors when reading the resource
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "animals")))
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "tags")))
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "detections")))
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "deployments")))
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "receivers")))
})

test_that("download_acoustic_dataset() returns CSV files with expected number of columns", {
  skip_if_no_authentication()

  datapackage <-
    suppressMessages(read_package(file.path(datapackage_path, "datapackage.json")))
  # Check the number of schema fields in the datapackage against the number of
  # columns in the csv files
  expect_length(
    names(readr::read_csv(
      file.path(datapackage_path, "animals.csv"),
      n_max = 0, show_col_types = FALSE
    )),
    length(fetch_schema_fields(datapackage, "animals"))
  )
  expect_length(
    names(readr::read_csv(
      file.path(datapackage_path, "tags.csv"),
      n_max = 0, show_col_types = FALSE
    )),
    length(fetch_schema_fields(datapackage, "tags"))
  )
  expect_length(
    names(readr::read_csv(
      file.path(datapackage_path, "detections.csv"),
      n_max = 0, show_col_types = FALSE
    )),
    length(fetch_schema_fields(datapackage, "detections"))
  )
  expect_length(
    names(readr::read_csv(
      file.path(datapackage_path, "deployments.csv"),
      n_max = 0, show_col_types = FALSE
    )),
    length(fetch_schema_fields(datapackage, "deployments"))
  )
  expect_length(
    names(readr::read_csv(
      file.path(datapackage_path, "receivers.csv"),
      n_max = 0, show_col_types = FALSE
    )),
    length(fetch_schema_fields(datapackage, "receivers"))
  )
})

test_that("download_acoustic_dataset() returns CSV files with columns in expected order", {
  skip_if_no_authentication()

  datapackage <-
    suppressMessages(read_package(file.path(datapackage_path, "datapackage.json")))
  # Check if the schema fields in the data package are exactly the same
  # (thus also in the same order) as the header of the csv files
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "animals"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(datapackage_path, "animals.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "tags"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(datapackage_path, "tags.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "detections"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(datapackage_path, "detections.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "deployments"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(datapackage_path, "deployments.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "receivers"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(datapackage_path, "receivers.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
})
