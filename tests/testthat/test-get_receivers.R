con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_receivers <- c(
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

receivers_all <- get_receivers(con)
receivers_project1 <- get_receivers(con, network_project_code = "thornton")
receivers_projects_multiple <- get_receivers(con, network_project_code = c("thornton", "leopold"))

testthat::test_that("test_input_get_receivers", {
  expect_error(
    get_receivers("I am not a connection"),
    "Not a connection object to database."
  )
  expect_error(get_receivers(con, network_project_code = "very_bad_project"))
  expect_error(get_receivers(con, network_project_code = c(
    "thornton",
    "very_bad_project"
  )))
})

testthat::test_that("test_output_get_receivers", {
  expect_is(receivers_all, "data.frame")
  expect_is(receivers_project1, "data.frame")
  expect_is(receivers_projects_multiple, "data.frame")
  expect_true(all(names(receivers_all) %in% expected_col_names_receivers))
  expect_true(all(expected_col_names_receivers %in% names(receivers_all)))
  expect_gt(nrow(receivers_all), nrow(receivers_project1))
  expect_gte(nrow(receivers_all), nrow(receivers_projects_multiple))
  expect_gte(nrow(receivers_projects_multiple), nrow(receivers_project1))
  expect_equal(nrow(receivers_all), nrow(receivers_all %>% distinct(pk)))
  expect_equal(nrow(receivers_all), nrow(receivers_all %>% distinct(receiver_id)))
  expect_equal(names(receivers_all), names(receivers_project1))
  expect_equal(names(receivers_all), names(receivers_projects_multiple))
})
