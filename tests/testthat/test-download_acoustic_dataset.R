con <- connect_to_etn()

# create a data package
evaluate_download <- evaluate_promise({
  download_acoustic_dataset(
    con,
    animal_project_code = "2014_demer",
    directory = tempdir()
  )
})

test_that("download_acoustic_dataset() creates the expected messages and files", {
  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "datapackage.json"
  )
  message <- readLines("./test-download_acoustic_dataset-message.txt")
  # Process output message
  message <- paste0(message, "\n")

  # Function creates the expected files
  expect_true(all(files_to_create %in% list.files(tempdir())))

  # Function returns the expected output message
  expect_true(all(tail(evaluate_download$messages, -1) == tail(message, -1)))

  # Function returns no warnings (character of length 0)
  expect_true(length(evaluate_download$warnings) == 0)

  # Function returns no result
  expect_null(evaluate_download$result)
})

test_that("download_acoustic_dataset() creates a valid Frictionless Data Package", {
  # fails eg. when a field was added to a get function but not to datapackage.json
  ## load datapackage
  datapackage <- frictionless::read_package(file.path(tempdir(), "datapackage.json"))
  ## check for errors when reading the resource
  expect_no_warning(frictionless::read_resource(datapackage, "animals"))
  expect_no_warning(frictionless::read_resource(datapackage, "tags"))
  expect_no_warning(frictionless::read_resource(datapackage, "detections"))
  expect_no_warning(frictionless::read_resource(datapackage, "deployments"))
  expect_no_warning(frictionless::read_resource(datapackage, "receivers"))
})

# TODO to be moved to R/testthat-helpers.R
fetch_schema_fields <- function(datapackage = datapackage, table_name) {
  datapackage[["resources"]][[
    match(
      table_name,
      sapply(
        datapackage[["resources"]],
        function(x) x[["name"]]
      )
    )
  ]][[
    "schema"
  ]][["fields"]]
}

test_that("the created csv files have the same number of columns as the schema in datapackage.json", {
  expect_length(
    fetch_schema_fields(datapackage, "animals"),
    ncol(readr::read_csv(file.path(tempdir(), "animals.csv"),
                         n_max = 0, show_col_types = FALSE))
  )
  expect_length(
    fetch_schema_fields(datapackage, "tags"),
    ncol(readr::read_csv(file.path(tempdir(), "tags.csv"),
                         n_max = 0, show_col_types = FALSE))
  )
  expect_length(
    fetch_schema_fields(datapackage, "detections"),
    ncol(readr::read_csv(file.path(tempdir(), "detections.csv"),
                         n_max = 0, show_col_types = FALSE))
  )
  expect_length(
    fetch_schema_fields(datapackage, "deployments"),
    ncol(readr::read_csv(file.path(tempdir(), "deployments.csv"),
                         n_max = 0, show_col_types = FALSE))
  )
  expect_length(
    fetch_schema_fields(datapackage, "receivers"),
    ncol(readr::read_csv(file.path(tempdir(), "receivers.csv"),
                         n_max = 0, show_col_types = FALSE))
  )
})

test_that(paste("the created csv files have the columns in the same order as",
                "the schema in datapackage.json"), {
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "animals"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(file.path(tempdir(), "animals.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "tags"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(file.path(tempdir(), "tags.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "detections"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(file.path(tempdir(), "detections.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "deployments"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(file.path(tempdir(), "deployments.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
  expect_identical(
    sapply(
      fetch_schema_fields(datapackage, "receivers"),
      function(x) x[["name"]]
    ),
    names(readr::read_csv(file.path(tempdir(), "receivers.csv"),
      n_max = 0, show_col_types = FALSE
    ))
  )
})
