# Test on a known deployment that has log_data.
test_deployment_id <- 53790

test_that("get_acoustic_deployment_logs() returns a tibble", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs")

  df <- get_acoustic_deployment_logs(deployment_id = test_deployment_id)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_acoustic_deployment_logs() returns an error on missing deployment_id", {
  expect_error(
    get_acoustic_deployment_logs(),
    class = "etn_no_dep_id_supplied"
  )
})

test_that("get_acoustic_deployment_logs() supports both int and chr deployment_id", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs_int_chr")

  expect_identical(
    get_acoustic_deployment_logs(deployment_id = as.character(test_deployment_id),
                      limit = TRUE),
    get_acoustic_deployment_logs(deployment_id = test_deployment_id,
                      limit = TRUE)
  )
})

test_that("get_acoustic_deployment_logs() returns a 0-row tbl if no receiver logs found", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs_none_found")

  expect_length(
    dplyr::pull(get_acoustic_deployment_logs(deployment_id = 1758), "deployment_id"),
    0L
  )
})

test_that("get_acoustic_deployment_logs() returns a warning for ids without logs", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  expect_warning(
    no_logs <- get_acoustic_deployment_logs(1758),
    class = "etn_no_deployment_logs_found"
  )
})

test_that("get_acoustic_deployment_logs() returns nice message on missing logs", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  # Test a mixture of ids with and without logs available for formatting of
  # warning message.
  ids_no_logs <- c(1758, 2489)
  ids_with_logs <- test_deployment_id
  expect_snapshot(
    get_acoustic_deployment_logs(c(ids_no_logs, ids_with_logs))
  )
})

test_that("get_acoustic_deployment_logs() can return a limited subset", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs_limit")

  # This test assumes that there are more than 100 logs for the test deployment
  expect_length(
    dplyr::pull(
      get_acoustic_deployment_logs(deployment_id = test_deployment_id, limit = TRUE),
      "deployment_id"
    ),
    100L
  )
})

test_that("get_acoustic_deployment_logs() returns at least the expected columns", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs_limit")

  expected_column_names <- c(
    "deployment_id",
    "receiver_id",
    "datetime",
    "record_type"
  )

  expect_contains(
    colnames(get_acoustic_deployment_logs(test_deployment_id, limit = TRUE)),
    expected_column_names
  )
})

test_that("get_acoustic_deployment_logs() returns expected columns for known deployment", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs_74145")

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
    get_acoustic_deployment_logs(deployment_id = known_cols_deployment_id,
                      # Limiting will return less columns
                      limit = FALSE),
    expected = expected_columns_known_id,
    ignore.order = TRUE # returned order is not guaranteed at the moment.
  )
})

test_that("get_acoustic_deployment_logs() returns the expected column classes", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs")

  expected_column_classes <- list(
    "deployment_id" = "integer",
    "receiver_id" = "character",
    "station_name" = "character",
    "datetime" = c("POSIXct", "POSIXt"),
    "record_type" = "character"
  )

  get_acoustic_deployment_logs(deployment_id = test_deployment_id) |>
    dplyr::select(dplyr::all_of(names(expected_column_classes))) |>
    purrr::map(class) |>
    expect_identical(expected_column_classes)

})

test_that("get_acoustic_deployment_logs() has no fully uppercase column names", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs_93144")

  # Testing conversion of uppercase database field names
  case_deployment_id <- 93144
  colnames_to_test_case <-
    colnames(get_acoustic_deployment_logs(deployment_id = case_deployment_id))

  expect_false(
    identical(
      colnames_to_test_case,
      toupper(colnames_to_test_case)
    )
  )
})

test_that("get_acoustic_deployment_logs() returns units in column names correctly", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  # Test that the conversion of uppercase doesn't result in incorrect units

  vcr::local_cassette("deployment_logs_units")

  # Query with some units in log_data
  receiver_log_data <- get_acoustic_deployment_logs(
    deployment_id = 6028
  )

  expect_match(
    names(receiver_log_data),
    regexp = "[A-Z]",
    all = FALSE # not all columns have uppercase units, but some do.
  )
})

test_that("get_acoustic_deployment_logs() returns no empty string values in log fields", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  # "" should be replaced with NA in any fields that are not deployment_id,
  # receiver_id, datetime or record_type

  vcr::local_cassette("deployment_logs_na_field")

  get_acoustic_deployment_logs(deployment_id = 65434) |>
    # Drop default columns
    dplyr::select(-dplyr::any_of(c("deployment_id",
                                   "receiver_id",
                                   "record_type",
                                   "datetime",
                                   "station_name"))) |>
    # Only keep rows with at least one empty string value
    dplyr::filter(
      dplyr::if_any(dplyr::where(is.character),
                    ~.x == "")
    ) |>
    # Count the number of rows, expect 0 rows to result from the filter
    dplyr::pull(var = 1) |>
    expect_length(0L)
})

test_that("get_acoustic_deployment_logs() returns unique rows for default columns", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs_na_field")

  receiver_log <-
    get_acoustic_deployment_logs(deployment_id = 65434)

  # Per group of identifying columns, no duplicate rows should
  # be present.

  expect_identical(
    receiver_log,
    dplyr::distinct(
      receiver_log,
      .data$deployment_id,
      .data$receiver_id,
      .data$station_name,
      .data$datetime,
      .data$record_type,
      .keep_all = TRUE
    )
  )

  dplyr::count(receiver_log,
               .data$deployment_id,
               .data$receiver_id,
               .data$station_name,
               .data$datetime,
               .data$record_type,
               name = "n",
               .drop = FALSE) |>
    # Only keep rows with more than one occurrence of the same combination of
    # identifying columns
    dplyr::filter(n > 1) |>
    # Pull deployment_id to check if any duplicate rows are present, expect 0
    # rows to result from the filter
    dplyr::pull("deployment_id") |>
    expect_length(0L)
})

test_that("get_acoustic_deployment_logs() handles duplicate columns by repairing them", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::local_cassette("deployment_logs_6028",
                      # Use qs2 serializer for a smaller cassette
                      serialize_with = "qs2")

  # deployment_id 6028 includes the station_name column in its log_data, causing
  # a collision with the station_name column added by the query.
  dup_col_deployment_id <- 6028

  # Message to list repaired column names, silence cli message
  expect_message(
    with_mocked_bindings(
      suppressMessages(
        get_acoustic_deployment_logs(deployment_id = dup_col_deployment_id),
        classes = "etn_message_name_repair"
      ),
      is_testing = \(x) {
        FALSE
      }
    ),
    class = "rlib_message_name_repair"
  )

  # Message informing name repair took place (cli), silence rlang message
  expect_message(
    with_mocked_bindings(
      suppressMessages(
        repaired <-
          get_acoustic_deployment_logs(deployment_id = dup_col_deployment_id),
        classes = "rlib_message_name_repair"
      ),
      is_testing = \(x) {
        FALSE
      }
    ),
    class = "etn_message_name_repair"
  )

  # Check that the duplicate column is repaired by make.unique and both columns
  # are present in the output
  expect_contains(
    names(repaired),
    c("station_name", "station_name.1")
  )
})
