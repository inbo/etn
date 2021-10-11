con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("Downloading the data package returns desired message and files", {
  # Arrange
  dir_to_download_data <- "./temp_download"
  dir.create(dir_to_download_data, recursive = TRUE, showWarnings = FALSE)
  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "datapackage.json"
  )
  message_2014_demer <- readLines(
    "./test-download_dataset-message.txt"
  )
  # Process output message
  message_2014_demer <- paste0(
    message_2014_demer, "\n")
  message_2014_demer <- c(
    paste0(message_2014_demer[1], message_2014_demer[2]),
    message_2014_demer[3:length(message_2014_demer)])

  # Act
  evaluate_download_2014_demer <- evaluate_promise({
    download_dataset_old(connection = con,
                     animal_project_code = "2014_demer",
                     directory = dir_to_download_data)
  })

  # Assert

  # Function creates the expected files
  expect_true(
    all(sort(list.files(dir_to_download_data)) == sort(files_to_create))
  )

  # Function returns the expected output message
  expect_true(
    all(evaluate_download_2014_demer$messages == message_2014_demer)
  )

  # Function returns no warnings (character of length 0)
  expect_true(length(evaluate_download_2014_demer$warnings) == 0)

  # Function returns no result
  expect_null(evaluate_download_2014_demer$result)

  # Function returns a verbose output of length 1
  expect_equal(length(evaluate_download_2014_demer$output), 1)
  expect_true(evaluate_download_2014_demer$output[1] != "")

  # Remove generated files and directories after test
  unlink(dir_to_download_data, recursive = TRUE)
  unlink("./data_test_download_dataset/detections.csv")
})
