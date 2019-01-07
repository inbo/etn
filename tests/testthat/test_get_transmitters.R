context("test_get_transmitters")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# valid column names
valid_col_names_transmitters <- c(
  "serial_number",
  "type",
  "model",
  "id_code",
  "tag_code_space",
  "owner_pi",
  "id_pk",
  "activation_date",
  "min_delay",
  "max_delay",
  "power",
  "end_date",
  "file",
  "estimated_lifetime",
  "sensor_type",
  "frequency",
  "acoustic_tag_type",
  "min_delay_step2",
  "max_delay_step2",
  "power_step2",
  "min_delay_step3",
  "max_delay_step3",
  "power_step3",
  "duration_step1",
  "duration_step2",
  "duration_step3",
  "manufacturer_fk",
  "intercept",
  "slope",
  "owner_group_fk",
  "thelma_converted_code",
  "financing_project_fk",
  "acceleration_on_sec_step1",
  "acceleration_on_sec_step2",
  "acceleration_on_sec_step3",
  "min_delay_step4",
  "max_delay_step4",
  "power_step4",
  "duration_step4",
  "acceleration_on_sec_step4",
  "range",
  "units",
  "accelerometer_algoritm",
  "accelerometer_samples_per_second",
  "sensor_transmit_ratio",
  "tag_full_id",
  "status",
  "projectcode"
)

test1 <- get_transmitters(con)
test2 <- get_transmitters(con, animal_project = "phd_reubens")
test3 <- get_transmitters(con, animal_project = c("phd_reubens",
                                                  "2012_leopoldkanaal"))
test4 <- get_transmitters(con,
                          animal_project = "phd_reubens",
                          include_reference_tags = TRUE)

testthat::test_that("test_input_get_transmitters", {
  expect_error(get_transmitters("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_transmitters(con, animal_project = "very_bad_project"))
  expect_error(get_transmitters(con, animal_project = c("phd_reubens",
                                                        "very_bad_project")))
  expect_error(get_transmitters(con, include_reference_tags = "not logical"))
})

testthat::test_that("test_output_get_transmitters", {
  library(dplyr)
  expect_is(test1, "data.frame")
  expect_is(test2, "data.frame")
  expect_is(test3, "data.frame")
  expect_is(test4, "data.frame")
  expect_true(all(names(test1) %in% valid_col_names_transmitters))
  expect_true(all(valid_col_names_transmitters %in% names(test1)))
  expect_gte(nrow(test1), nrow(test2))
  expect_gte(nrow(test1), nrow(test3))
  expect_gte(nrow(test3), nrow(test2))
  expect_gte(nrow(test4), nrow(test2))
  expect_equal(names(test1), names(test2))
  expect_equal(names(test1), names(test3))
  expect_equal(names(test1), names(test4))
  expect_equal(test2 %>%
                 distinct(acoustic_tag_type) %>%
                 pull(), c("sentinel","animal"))
})
