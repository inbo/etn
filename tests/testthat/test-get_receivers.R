# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Valid column names
valid_col_names_receivers <- c(
  "pk",
  "receiver_id",
  "network_project_code",
  "application_type",
  "telemetry_type",
  "manufacturer",
  "receiver_id_model",
  "receiver_id_serial_number",
  "modem_address",
  "status",
  "battery_estimated_life",
  "owner_organization",
  "financing_project",
  "built_in_tag_id",
  "ar_model_number",
  "ar_serial_number",
  "ar_battery_estimated_life",
  "ar_voltage_at_deploy",
  "ar_interrogate_code",
  "ar_receive_frequency",
  "ar_reply_frequency",
  "ar_ping_rate",
  "ar_enable_code_address",
  "ar_release_code",
  "ar_disable_code",
  "ar_tilt_code",
  "ar_tilt_after_deploy"
)

test1 <- get_receivers(con)
test2 <- get_receivers(con, network_project = "thornton")
test3 <- get_receivers(con, network_project = c("thornton", "leopold"))

testthat::test_that("test_input_get_receivers", {
  expect_error(get_receivers("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_receivers(con, network_project = "very_bad_project"))
  expect_error(get_receivers(con, network_project = c("thornton",
                                                      "very_bad_project")))
})

testthat::test_that("test_output_get_receivers", {
  expect_is(test1, "data.frame")
  expect_is(test2, "data.frame")
  expect_is(test3, "data.frame")
  expect_true(all(names(test1) %in% valid_col_names_receivers))
  expect_true(all(valid_col_names_receivers %in% names(test1)))
  expect_gt(nrow(test1), nrow(test2))
  expect_gte(nrow(test1), nrow(test3))
  expect_gte(nrow(test3), nrow(test2))
  expect_equal(nrow(test1), nrow(test1 %>% distinct(pk)))
  expect_equal(nrow(test1), nrow(test1 %>% distinct(receiver_id)))
  expect_equal(names(test1), names(test2))
  expect_equal(names(test1), names(test3))
})
