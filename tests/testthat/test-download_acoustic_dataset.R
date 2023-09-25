con <- connect_to_etn()

# Create a data package
evaluate_download <- evaluate_promise({
  download_acoustic_dataset(
    con,
    animal_project_code = "2014_demer",
    directory = tempdir()
  )
})

test_that("download_acoustic_dataset() creates the expected files", {
  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "datapackage.json"
  )
  # Function creates the expected files
  expect_true(all(files_to_create %in% list.files(tempdir())))
})

test_that("download_acoustic_dataset() does not warnings for valid dataset", {
  # Function returns no warnings (character of length 0)
  expect_true(length(evaluate_download$warnings) == 0)
})

test_that("download_acoustic_dataset() returns message and summary stats", {
  # call download_acoustic_dataset() and capture the output, compare to a local
  # file. Covers warnings and messages, but will fail on an error.
  expect_snapshot(cat(download_acoustic_dataset(
    con,
    animal_project_code = "2014_demer"
  )))
  # After running, remove the files we just created
  withr::defer(unlink("2014_demer"))
})

test_that("download_acoustic_dataset() creates the expected files", {
  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "datapackage.json"
  )

  # Function creates the expected files
  expect_true(all(files_to_create %in% list.files(tempdir())))

  # Function returns no result
  expect_null(evaluate_download$result)
})

test_that("download_acoustic_dataset() creates a valid Frictionless Data Package", {
  # This will fail when a field is added to a get_ function but not to datapackage.json
  datapackage <-
    suppressMessages(frictionless::read_package(file.path(tempdir(), "datapackage.json")))
  ## Check for errors when reading the resource
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "animals")))
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "tags")))
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "detections")))
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "deployments")))
  expect_no_warning(suppressMessages(frictionless::read_resource(datapackage, "receivers")))
})


test_that("download_acoustic_dataset() returns CSV files with expected columns", {
  datapackage <-
    suppressMessages(frictionless::read_package(file.path(tempdir(), "datapackage.json")))
  # Check the number of schema fields in the datapackage against the number of
  # columns in the csv files
  expect_length(
    fetch_schema_fields(datapackage, "animals"),
    ncol(readr::read_csv(
      file.path(tempdir(), "animals.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_length(
    fetch_schema_fields(datapackage, "tags"),
    ncol(readr::read_csv(
      file.path(tempdir(), "tags.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_length(
    fetch_schema_fields(datapackage, "detections"),
    ncol(readr::read_csv(
      file.path(tempdir(), "detections.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_length(
    fetch_schema_fields(datapackage, "deployments"),
    ncol(readr::read_csv(
      file.path(tempdir(), "deployments.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_length(
    fetch_schema_fields(datapackage, "receivers"),
    ncol(readr::read_csv(
      file.path(tempdir(), "receivers.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
})

test_that("download_acoustic_dataset() returns CSV files with columns in expected order", {
  datapackage <-
    suppressMessages(frictionless::read_package(file.path(tempdir(), "datapackage.json")))
  # Check if the schema fields in the data package are exactly the same
  # (thus also in the same order) as the header of the csv files
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "animals"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(tempdir(), "animals.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "tags"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(tempdir(), "tags.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "detections"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(tempdir(), "detections.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "deployments"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(tempdir(), "deployments.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "receivers"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(
      file.path(tempdir(), "receivers.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
})
