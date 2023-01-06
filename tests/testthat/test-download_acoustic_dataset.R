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
  expect_true(all(tail(evaluate_download$messages,-1) == tail(message,-1)))

  # Function returns no warnings (character of length 0)
  expect_true(length(evaluate_download$warnings) == 0)

  # Function returns no result
  expect_null(evaluate_download$result)

})
