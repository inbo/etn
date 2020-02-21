con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_tags <- c(
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

tags_all <- get_tags(con)
tags_project1 <- get_tags(con, animal_project_code = "phd_reubens")
tags_projects_multiple <- get_tags(con, animal_project_code = c(
  "phd_reubens",
  "2012_leopoldkanaal"
))
tags_project1_ref <- get_tags(con,
  animal_project_code = "phd_reubens",
  include_reference_tags = TRUE
)

testthat::test_that("test_input_get_tags", {
  expect_error(
    get_tags("I am not a connection"),
    "Not a connection object to database."
  )
  expect_error(get_tags(con, animal_project_code = "very_bad_project"))
  expect_error(get_tags(con, animal_project_code = c(
    "phd_reubens",
    "very_bad_project"
  )))
  expect_error(get_tags(con, include_reference_tags = "not logical"))
})

testthat::test_that("test_output_get_tags", {
  library(dplyr)
  expect_is(tags_all, "data.frame")
  expect_is(tags_project1, "data.frame")
  expect_is(tags_projects_multiple, "data.frame")
  expect_is(tags_project1_ref, "data.frame")
  expect_true(all(names(tags_all) %in% expected_col_names_tags))
  expect_true(all(expected_col_names_tags %in% names(tags_all)))
  expect_gte(nrow(tags_all), nrow(tags_project1))
  expect_gte(nrow(tags_all), nrow(tags_projects_multiple))
  expect_gte(nrow(tags_projects_multiple), nrow(tags_project1))
  expect_gte(nrow(tags_project1_ref), nrow(tags_project1))
  expect_equal(names(tags_all), names(tags_project1))
  expect_equal(names(tags_all), names(tags_projects_multiple))
  expect_equal(names(tags_all), names(tags_project1_ref))
  expect_equal(
    tags_project1 %>% distinct(type) %>% arrange() %>% pull(),
    c("animal", "sentinel")
  )
  # expect_equal(nrow(tags_all), nrow(tags_all %>% distinct(pk)))
  # expect_equal(nrow(tags_all), nrow(tags_all %>% distinct(tag_id)))
})
