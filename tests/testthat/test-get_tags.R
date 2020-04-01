con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names <- c(
  "pk",
  "tag_id",
  "tag_id_alternative",
  "telemetry_type",
  "manufacturer",
  "model",
  "frequency",
  "type",
  "serial_number",
  "tag_id_protocol",
  "tag_id_code",
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

tag1 <- "A69-1303-65313" # A sentinel tag with 2 records
tag_multiple <- c("A69-1601-1705", "A69-1601-1707")

tags_all <- get_tags(con)
tags_all_ref <- get_tags(con, include_ref_tags = TRUE)
tags_tag1 <- get_tags(con, tag_id = tag1)
tags_tag_multiple <- get_tags(con, tag_id = tag_multiple)

testthat::test_that("Test input", {
  expect_error(
    get_tags("not_a_connection"),
    "Not a connection object to database."
  )
  expect_error(
    get_tags(con, tag_id = "not_a_tag_id")
  )
  expect_error(
    get_tags(con, tag_id = c("A69-1601-1705", "not_a_tag_id"))
  )
  expect_error(
    get_tags(con, include_ref_tags = "not_a_logical")
  )
})

testthat::test_that("Test output type", {
  expect_is(tags_all, "data.frame")
  expect_is(tags_all_ref, "data.frame")
  expect_is(tags_tag1, "data.frame")
  expect_is(tags_tag_multiple, "data.frame")
})

testthat::test_that("Test column names", {
  expect_equal(names(tags_all), expected_col_names)
  expect_equal(names(tags_all_ref), expected_col_names)
  expect_equal(names(tags_tag1), expected_col_names)
  expect_equal(names(tags_tag_multiple), expected_col_names)
})

testthat::test_that("Test number of records", {
  expect_gt(nrow(tags_all_ref), nrow(tags_all))
  expect_equal(nrow(tags_tag1), 2)
  expect_equal(nrow(tags_tag_multiple), 2)
})

testthat::test_that("Test if data is filtered on parameter", {
  expect_equal(
    tags_tag1 %>% distinct(tag_id) %>% pull(),
    c(tag1)
  )
  expect_equal(
    tags_tag_multiple %>% distinct(tag_id) %>% arrange(tag_id) %>% pull(),
    tag_multiple
  )
})

testthat::test_that("Test unique ids", {
  expect_equal(nrow(tags_all), nrow(tags_all %>% distinct(pk)))
  # expect_equal(nrow(tags_all), nrow(tags_all %>% distinct(tag_id))) # This is not the case
})
