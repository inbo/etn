con <- connect_to_etn()

test_that("download_acoustic_dataset() creates the expected messages and files", {
  download_dir <- "./temp_download"
  dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)
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
  message <- c(paste0(message[1], message[2]), message[3:length(message)])

  # Run function
  evaluate_download <- evaluate_promise({
    download_acoustic_dataset(
      con,
      animal_project_code = "2014_demer",
      directory = download_dir
    )
  })

  # Function creates the expected files
  expect_true(all(sort(list.files(download_dir)) == sort(files_to_create)))

  # Function returns the expected output message
  expect_true(all(evaluate_download$messages == message))

  # Function returns no warnings (character of length 0)
  expect_true(length(evaluate_download$warnings) == 0)

  # Function returns no result
  expect_null(evaluate_download$result)

  # Function returns a verbose output of length 1
  expect_equal(length(evaluate_download$output), 1)
  expect_true(evaluate_download$output[1] != "")

  # Remove generated files and directories after test
  unlink(download_dir, recursive = TRUE)
})
