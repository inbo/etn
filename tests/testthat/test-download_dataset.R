library(mockery)

con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("Downloading the data package returns desired message and files", {

  # Arrange

  dir_to_download_data <- "./temp_download"
  dir.create(dir_to_download_data, recursive = TRUE, showWarnings = TRUE)

  # list files will be create
  files_to_create <- c("animals.csv",
                       "tags.csv",
                       "detections.csv",
                       "deployments.csv",
                       "receivers.csv",
                       "datapackage.json")

  # read target message
  output_message_2015_homarus <- readLines(
    paste0("./data_test_download_dataset",
           "/output_message_download_dataset_2015_homarus.txt")
  )

  # Shape target message
  output_message_2015_homarus <- paste0(
    output_message_2015_homarus, "\n")
  output_message_2015_homarus <- c(
    paste0(output_message_2015_homarus[1], output_message_2015_homarus[2]),
    output_message_2015_homarus[3:length(output_message_2015_homarus)])


  # Read csv with detections for stubbing (getting detections takes too long)
  detections_2015_homarus <- read.csv(
    "./data_test_download_dataset/2015_homarus_detections_stubbed.csv",
    header = TRUE,
    stringsAsFactors = FALSE)

  # Stub download_dataset() out by mocking the get_detections() step
  stub(download_dataset, "get_detections", detections_2015_homarus)


  # Act

  evaluate_download_2015_homarus <- evaluate_promise(
    download_dataset(connection = con,
                     animal_project_code = "2015_homarus",
                     directory = dir_to_download_data)
  )


  # Assert

  # Function creates the expected files
  expect_true(all(sort(list.files("temp_download/")) == sort(files_to_create)))

  # Function returns the expected output message
  expect_true(
    all(
      evaluate_download_2015_homarus$messages ==
        output_message_2015_homarus)
  )

  # Function returns no warnings (character of length 0)
  expect_true(length(evaluate_download_2015_homarus$warnings) == 0)

  # Function returns no result
  expect_null(evaluate_download_2015_homarus$result)

  # Function returns no output
  expect_true(evaluate_download_2015_homarus$output == "")


  # Remove generated files and directories after test
  unlink(dir_to_download_data, recursive = TRUE)
})
