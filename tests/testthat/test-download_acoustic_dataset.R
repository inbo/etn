test_that("download_acoustic_dataset() creates the expected messages and files using api", {
  download_dir <- file.path(tempdir(), "using_api")
  dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)

  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "datapackage.json"
  )

  expect_snapshot(
    download_acoustic_dataset(
      api = TRUE,
      animal_project_code = "2014_demer",
      directory = download_dir
    ),
    transform = ~ stringr::str_remove(.x, pattern = "(?=`\\/).+(?<=`)"),
    variant = "api"
  )

  # Function creates the expected files
  expect_true(all(files_to_create %in% list.files(download_dir)))

  # Remove generated files and directories after test
  unlink(download_dir, recursive = TRUE)
})

test_that("download_acoustic_dataset() creates the expected messages and files using local db", {
  download_dir <- file.path(tempdir(), "using_sql")
  dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)

  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "datapackage.json"
  )

  expect_snapshot(
    download_acoustic_dataset(
      api = FALSE,
      animal_project_code = "2014_demer",
      directory = download_dir
    ),
    transform = ~ stringr::str_remove(.x, pattern = "(?=`\\/).+(?<=`)"),
    variant = "sql"
  )

  # Function creates the expected files
  expect_true(all(files_to_create %in% list.files(download_dir)))

  # Remove generated files and directories after test
  unlink(download_dir, recursive = TRUE)
})
