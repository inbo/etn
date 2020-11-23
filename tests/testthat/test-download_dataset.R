con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("Downloading the data package returns desired message and files", {
  # Arrange
  dir_to_download_data <- "./temp_download"
  dir.create(dir_to_download_data, recursive = TRUE, showWarnings = TRUE)
  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "datapackage.json"
  )
  message_2015_homarus <- readLines(
    "./test-download_dataset-message.txt"
  )
  # Process output message
  message_2015_homarus <- paste0(
    message_2015_homarus, "\n")
  message_2015_homarus <- c(
    paste0(message_2015_homarus[1], message_2015_homarus[2]),
    message_2015_homarus[3:length(message_2015_homarus)])

  # Act
  evaluate_download_2015_homarus <- evaluate_promise({
    download_dataset(connection = con,
                     animal_project_code = "2015_homarus",
                     directory = dir_to_download_data)
  })

  # Assert

  # Function creates the expected files
  expect_true(
    all(sort(list.files(dir_to_download_data)) == sort(files_to_create))
  )

  # Function returns the expected output message
  expect_true(
    all(evaluate_download_2015_homarus$messages == message_2015_homarus)
  )

  # Function returns no warnings (character of length 0)
  expect_true(length(evaluate_download_2015_homarus$warnings) == 0)

  # Function returns no result
  expect_null(evaluate_download_2015_homarus$result)

  # Function returns no output
  expect_true(evaluate_download_2015_homarus$output == "")

  # Remove generated files and directories after test
  unlink(dir_to_download_data, recursive = TRUE)
  unlink("./data_test_download_dataset/detections.csv")
})
