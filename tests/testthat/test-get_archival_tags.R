con <- connect_to_etn()

test_that("get_archival_tags() returns error for incorrect connection", {
  expect_error(
    get_archival_tags(con = "not_a_connection"),
    "Not a connection object to database."
  )
})

test_that("get_archival_tags() returns a tibble", {
  df <- get_archival_tags(con)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_archival_tags() returns the expected columns", {
  df <- get_archival_tags(con)
  expected_col_names <- c(
    "tag_serial_number",
    "tag_type",
    "tag_subtype",
    "tag_id",
    "archival_tag_id",
    "sensor_type",
    "manufacturer",
    "model",
    "frequency",
    "status",
    "activation_date",
    "battery_estimated_life",
    "battery_estimated_end_date",
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

test_that("get_archival_tags() return tags of type 'archival'", {
  expect_equal(
    get_archival_tags(con) %>% distinct(tag_type) %>% pull(),
    "archival"
  )
})

test_that("get_archival_tags() allows selecting on tag_serial_number", {
  # Errors
  expect_error(get_archival_tags(con, tag_serial_number = "0")) # Not an existing value
  expect_error(get_archival_tags(con, tag_serial_number = c("1292638", "0")))

  # Select single value
  single_select <- "1292638" # From PhD_Goossens
  single_select_df <- get_archival_tags(con, tag_serial_number = single_select)
  expect_equal(
    single_select_df %>% distinct(tag_serial_number) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 2) # temperature + pressure

  # Select multiple values
  multi_select <- c(1292638, "1292639") # Integers are allowed
  multi_select_df <- get_archival_tags(con, tag_serial_number = multi_select)
  expect_equal(
    multi_select_df %>% distinct(tag_serial_number) %>% pull() %>% sort(),
    c(as.character(multi_select)) # Output will be all character
  )
  expect_equal(nrow(multi_select_df), 4) # 2x temperature + pressure
})

test_that("get_archival_tags() allows selecting on archival_tag_id", {
  # Errors
  expect_error(get_archival_tags(con, archival_tag_id = "0")) # Not an existing value
  expect_error(get_archival_tags(con, archival_tag_id = c("3638", "0")))

  # Select single value
  single_select <- "3638" # From PhD_Goossens
  single_select_df <- get_archival_tags(con, archival_tag_id = single_select)
  expect_equal(
    single_select_df %>% distinct(archival_tag_id) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 1)
  # Note that we expect a single record per get_archival_id, but many are NA

  # Select multiple values
  multi_select <- c(3638, "3639") # Integers are allowed
  multi_select_df <- get_archival_tags(con, archival_tag_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(archival_tag_id) %>% pull() %>% sort(),
    c(as.character(multi_select))
  )
  expect_equal(nrow(multi_select_df), 2)
})
