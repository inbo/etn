con <- connect_to_etn()

test_that("get_tags() returns error for incorrect connection", {
  expect_error(
    get_tags(con = "not_a_connection"),
    "Not a connection object to database."
  )
})

test_that("get_tags() returns a tibble", {
  df <- get_tags(con)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_tags() returns the expected columns", {
  df <- get_tags(con)
  expected_col_names <- c(
    "tag_serial_number",
    "tag_type",
    "tag_subtype",
    "sensor_type",
    "acoustic_tag_id",
    "acoustic_tag_id_alternative",
    "manufacturer",
    "model",
    "frequency",
    "status",
    "activation_date",
    "battery_estimated_life",
    "battery_estimated_end_date",
    "resolution",
    "unit",
    "accuracy",
    "range_min",
    "range_max",
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
    "step4_acceleration_duration",
    "tag_device_id"
  )
  expect_equal(names(df), expected_col_names)
})

test_that("get_tags() allows selecting on tag_serial_number", {
  # Errors
  expect_error(get_tags(con, tag_serial_number = "0")) # Not an existing value
  expect_error(get_tags(con, tag_serial_number = c("1187450", "0")))

  # Select single value
  single_select <- "1187450" # From 2014_demer
  single_select_df <- get_tags(con, tag_serial_number = single_select)
  expect_equal(
    single_select_df %>% distinct(tag_serial_number) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 1)
  # Note that not all tag_serial_number return a single row, see further test

  # Select multiple values
  multi_select <- c(1187449, "1187450") # Integers are allowed
  multi_select_df <- get_tags(con, tag_serial_number = multi_select)
  expect_equal(
    multi_select_df %>% distinct(tag_serial_number) %>% pull() %>% sort(),
    c(as.character(multi_select)) # Output will be all character
  )
  expect_equal(nrow(multi_select_df), 2)
})

test_that("get_tags() allows selecting on tag_type", {
  # Errors
  expect_error(get_tags(con, tag_type = "not_a_tag_type"))
  expect_error(get_tags(con, tag_type = c("archival", "not_a_tag_type")))

  # Select single value
  single_select <- "archival"
  single_select_df <- get_tags(con, tag_type = single_select)
  expect_equal(
    single_select_df %>% distinct(tag_type) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("acoustic-archival", "archival")
  multi_select_df <- get_tags(con, tag_type = multi_select)
  expect_equal(
    multi_select_df %>% distinct(tag_type) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_tags() allows selecting on tag_subtype", {
  # Errors
  expect_error(get_tags(con, tag_subtype = "not_a_tag_subtype"))
  expect_error(get_tags(con, tag_subtype = c("archival", "not_a_tag_subtype")))

  # Select single value
  single_select <- "built-in"
  single_select_df <- get_tags(con, tag_subtype = single_select)
  expect_equal(
    single_select_df %>% distinct(tag_subtype) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("built-in", "range")
  multi_select_df <- get_tags(con, tag_subtype = multi_select)
  expect_equal(
    multi_select_df %>% distinct(tag_subtype) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_tags() allows selecting on acoustic_tag_id", {
  # Errors
  expect_error(get_tags(con, acoustic_tag_id = "not_a_tag_id"))
  expect_error(get_tags(con, acoustic_tag_id = c("A69-1601-16130", "not_a_tag_id")))

  # Select single value
  single_select <- "A69-1601-16130" # From 2014_demer
  single_select_df <- get_tags(con, acoustic_tag_id = single_select)
  expect_equal(
    single_select_df %>% distinct(acoustic_tag_id) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 1)
  # Note that not all acoustic_tag_id return a single row, e.g. "A180-1702-48973"

  # Select multiple values
  multi_select <- c("A69-1601-16129", "A69-1601-16130")
  multi_select_df <- get_tags(con, acoustic_tag_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(acoustic_tag_id) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_equal(nrow(multi_select_df), 2)
})

test_that("get_tags() allows selecting on multiple parameters", {
  multiple_parameters_df <- get_tags(
    con,
    tag_serial_number = "1187450",
    tag_type = "acoustic",
    tag_subtype = "animal",
    acoustic_tag_id = "A69-1601-16130"
  )
  expect_equal(nrow(multiple_parameters_df), 1)
})

test_that("get_tags() can return multiple rows for a single tag", {
  # A sentinel acoustic-archival tag with pressure + temperature sensor
  tag_1_df <- get_tags(con, tag_serial_number = 1400185)
  expect_equal(nrow(tag_1_df), 2) # 2 rows: presure + temperature
  expect_equal(
    tag_1_df %>% distinct(tag_type, tag_subtype, sensor_type, acoustic_tag_id),
    as_tibble(data.frame(
      tag_type = "acoustic-archival",
      tag_subtype = "sentinel",
      sensor_type = c("pressure", "temperature"),
      acoustic_tag_id = c("A69-9006-11100", "A69-9006-11099"),
      stringsAsFactors = FALSE
    ))
  )

  # A built-in acoustic tag with two protocols: https://github.com/inbo/etn/issues/177#issuecomment-925578186
  tag_2_df <- get_tags(con, tag_serial_number = 461076)
  expect_equal(nrow(tag_2_df), 2) # 2 rows: H170 + A180
  expect_equal(
    tag_2_df %>% distinct(tag_type, tag_subtype, sensor_type, acoustic_tag_id),
    as_tibble(data.frame(
      tag_type = "acoustic",
      tag_subtype = "built-in",
      sensor_type = NA_character_,
      acoustic_tag_id = c("H170-1802-62076", "A180-1702-62076"),
      stringsAsFactors = FALSE
    ))
  )
})

test_that("get_tags() returns correct tag_type and tag_subtype", {
  df <- get_tags(con)
  expect_equal(
    df %>% distinct(tag_type) %>% pull() %>% sort(),
    c("acoustic", "acoustic-archival", "archival")
  )
  expect_equal(
    df %>% distinct(tag_subtype) %>% pull() %>% sort(),
    c("animal", "built-in", "range", "sentinel")
  )
})
