con <- connect_to_etn()

test_that("get_receiver_diagnostics() returns error for incorrect connection", {
  expect_error(
    get_acoustic_detections(con = "not_a_connection"),
    "Not a connection object to database."
  )
})

# Store the first 100 rows of the receiver diagnostics data for use in tests
df <- get_receiver_diagnostics(con, limit = TRUE)

test_that("get_receiver_diagnostics() returns a tibble", {
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_receiver_diagnostics() returns the expected columns", {
  expected_column_names <-
    c(
      "receiver_id",
      "deployment_id",
      "datetime",
      "record_type",
      "time",
      "pings",
      "detections",
      "noise",
      "tilt",
      "time_offset",
      "time_correction",
      "ambient",
      "internal",
      "depth"
    )
  expect_identical(colnames(df),
                   expected_column_names)
})

test_that("get_receiver_diagnostics() allows for filtering on start_date and end_date",{

})
