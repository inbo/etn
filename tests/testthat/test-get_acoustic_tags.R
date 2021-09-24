con <- connect_to_etn()

test_that("get_acoustic_tags() returns error for incorrect connection", {
  expect_error(
    get_acoustic_tags(con = "not_a_connection"),
    "Not a connection object to database."
  )
})

test_that("get_acoustic_tags() returns a tibble", {
  df <- get_acoustic_tags()
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_acoustic_tags() returns unique tag_id", {
  # TODO: FAILS, see https://github.com/inbo/etn/issues/176
  # df <- get_acoustic_tags()
  # expect_equal(nrow(df), nrow(df %>% distinct(tag_id)))
})

test_that("get_acoustic_tags() returns the expected columns", {
  df <- get_acoustic_tags()
  expected_col_names <- c(
    "tag_serial_number",
    "tag_type",
    "tag_subtype",
    "tag_id",
    "acoustic_tag_id",
    "acoustic_tag_id_alternative",
    "manufacturer",
    "model",
    "frequency",
    "acoustic_tag_id_protocol",
    "acoustic_tag_id_code",
    "status",
    "activation_date",
    "battery_estimated_life",
    "battery_estimated_end_date",
    "sensor_type",
    "sensor_slope",
    "sensor_intercept",
    "sensor_range",
    "sensor_transmit_ratio",
    "accelerometer_algorithm",
    "accelerometer_samples_per_second",
    "owner_organization",
    "owner_pi",
    "financing_project",
    "step1_min_delay",
    "step1_max_delay",
    "step1_power",
    "step1_duration",
    "step1_acceleration_duration",
    "step2_min_delay",
    "step2_max_delay",
    "step2_power",
    "step2_duration",
    "step2_acceleration_duration",
    "step3_min_delay",
    "step3_max_delay",
    "step3_power",
    "step3_duration",
    "step3_acceleration_duration",
    "step4_min_delay",
    "step4_max_delay",
    "step4_power",
    "step4_duration",
    "step4_acceleration_duration"
  )
  expect_equal(names(df), expected_col_names)
})

test_that("get_acoustic_tags() allows selecting on tag_serial_number", {
  # Errors
  expect_error(get_acoustic_tags(tag_serial_number = "0")) # Not an existing tag_serial_number
  expect_error(get_animals(animal_id = c("1157779", "0")))

  # Select single value
  single_select <- "1157779" # From 2014_demer
  single_select_df <- get_acoustic_tags(tag_serial_number = single_select)
  expect_equal(
    single_select_df %>% distinct(tag_serial_number) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 1)
  # Note that not all tag_serial_number return a single row, e.g. "461076"

  # Select multiple values
  multi_select <- c(1157779, "1157780") # Integers are allowed
  multi_select_df <- get_acoustic_tags(tag_serial_number = multi_select)
  expect_equal(
    multi_select_df %>% distinct(tag_serial_number) %>% pull() %>% sort(),
    c(as.character(multi_select)) # Output will be all character
  )
  expect_equal(nrow(multi_select_df), 2)
})

test_that("get_acoustic_tags() allows selecting on acoustic_tag_id", {
  # Errors
  expect_error(get_acoustic_tags(acoustic_tag_id = "0")) # Not an existing acoustic_tag_id
  expect_error(get_animals(acoustic_tag_id = c("A69-1601-28294", "0")))

  # Select single value
  single_select <- "A69-1601-28294" # From 2014_demer
  single_select_df <- get_acoustic_tags(acoustic_tag_id = single_select)
  expect_equal(
    single_select_df %>% distinct(acoustic_tag_id) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 1)
  # Note that not all acoustic_tag_id return a single row, e.g. "A180-1702-48973"

  # Select multiple values
  multi_select <- c("A69-1601-28294", "A69-1601-28295")
  multi_select_df <- get_acoustic_tags(acoustic_tag_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(acoustic_tag_id) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_equal(nrow(multi_select_df), 2)
})
