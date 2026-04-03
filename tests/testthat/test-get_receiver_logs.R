# Test on a known deployment that has log_data.
test_deployment_id <- 53790

test_that("get_receiver_logs() returns a tibble", {
  df <- get_receiver_logs(deployment_id = test_deployment_id)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_receiver_logs() returns an error on missing deployment_id", {

})

test_that("get_receiver_logs() returns a warning if no receiver logs found", {

})

test_that("get_receiver_logs() supports both integer and string deployment_id", {

})

test_that("get_receiver_logs() returns a 0-row tibble if no receiver logs found", {
  expect_length(
    dplyr::pull(get_receiver_logs(deployment_id = 1758), "deployment_id"),
    0L
  )
})



test_that("get_receiver_logs() can filter on start_date", {

})

test_that("get_receiver_logs() can filter on end_date", {

})

test_that("get_receiver_logs() can return a limited subset", {
  # This test assumes that there are more than 100 logs for the test deployment
  expect_length(
    dplyr::pull(
      get_receiver_logs(deployment_id = test_deployment_id, limit = TRUE),
      "deployment_id"
    ),
    100L
  )
})

test_that("get_receiver_logs() returns at least the expected columns", {
  expected_column_names <- c(
    "deployment_id",
    "receiver_id",
    "datetime",
    "record_type"
  )

  expect_contains(
    colnames(get_receiver_logs(test_deployment_id, limit = TRUE)),
    expected_column_names
  )
})

test_that("get_receiver_logs() returns expected columns for known deployment", {
  # Not every receiver log contains the same columns, this test check for
  # columns known to occur for this specific deployment id

  known_cols_deployment_id <- 74145
  expected_columns_known_id <-
    c(
      "deployment_id",
      "receiver_id",
      "record_type",
      "datetime",
      "station_name",
      "battery_position",
      "device_time_UTC",
      "battery_voltage_V",
      "ambient_deg_C",
      "depth_m",
      "tilt_deg",
      "PPM_pings",
      "PPM_detections",
      "noise_mean_mV",
      "ambient_temperature_deg_C",
      "memory_remaining_%",
      "ID",
      "full_ID",
      "power_level",
      "max_delay_s",
      "min_delay_s",
      "transmission_type",
      "description",
      "event_type",
      "source",
      "external_time_UTC",
      "external_difference_s",
      "original_file",
      "external_time_zone",
      "PPM_total_accepted_detections",
      "station_name.1",
      "firmware_version",
      "prior_device_time_UTC",
      "index",
      "decoder",
      "PPM_map_ID",
      "HR_coding_ID",
      "frequency_khz"
    )

  expect_named(
    get_receiver_logs(deployment_id = known_cols_deployment_id,
                      # Limiting will return less columns
                      limit = FALSE),
    expected = expected_columns_known_id
  )
})

test_that("get_receiver_logs() returns the expected column classes", {
  expected_column_classes <- list(
    "deployment_id" = "integer",
    "receiver_id" = "character",
    "station_name" = "character",
    "datetime" = c("POSIXct", "POSIXt"),
    "record_type" = "character"
  )

  get_receiver_logs(deployment_id = test_deployment_id) |>
    dplyr::select(dplyr::all_of(names(expected_column_classes))) |>
    purrr::map(class) |>
    expect_identical(expected_column_classes)

})

test_that("get_receiver_logs() has no fully uppercase column names", {
  # Testing conversion of uppercase database field names
  case_deployment_id <- 93144
  colnames_to_test_case <-
    colnames(get_receiver_logs(deployment_id = case_deployment_id))

  expect_false(
    identical(
      colnames_to_test_case,
      toupper(colnames_to_test_case)
    )
  )
})

test_that("get_receiver_logs() returns units in column names correctly", {
  # Test that the conversion of uppercase doesn't result in incorrect units

})

test_that("get_receiver_logs() returns no empty string values in log fields", {
  # "" should be replaced with NA in any fields that are not deployment_id,
  # receiver_id, datetime or record_type
})

test_that("get_receiver_logs() returns unique rows per ids, datetime, record_type", {
  receiver_log <-
    get_receiver_logs(deployment_id = 65434)

  expect_identical(
    receiver_log,
    dplyr::distinct(
      receiver_log,
      deployment_id,
      receiver_id,
      station_name,
      datetime,
      record_type,
      .keep_all = TRUE
    )
  )
})

test_that("get_receiver_logs() can handle logs with multiple values", {
  #coalesce works

  # this deployment causes an error on the pings column
  expect_no_error(get_receiver_logs(deployment_id = 6028))
})
