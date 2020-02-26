con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_receivers <- c(
  "pk",
  "receiver_id",
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

receiver1 <- "VR2-4842c"
receiver_multiple <- c("VR2AR-545719", "VR2AR-545720")

receivers_all <- get_receivers(con)
receivers_receiver1 <- get_receivers(con, receiver_id = receiver1)
receivers_receiver_multiple <- get_receivers(con, receiver_id = receiver_multiple)

testthat::test_that("Test input", {
  expect_error(
    get_receivers("not_a_connection"),
    "Not a connection object to database."
  )
  expect_error(
    get_receivers(con, receiver_id = "not_a_receiver_id")
  )
  expect_error(
    get_receivers(con, receiver_id = c("VR2AR-545719", "not_a_receiver_id"))
  )
})

testthat::test_that("Test output type", {
  expect_is(receivers_all, "data.frame")
  expect_is(receivers_receiver1, "data.frame")
  expect_is(receivers_receiver_multiple, "data.frame")
})

testthat::test_that("Test column names", {
  expect_true(all(names(receivers_all) %in% expected_col_names_receivers))
  expect_true(all(expected_col_names_receivers %in% names(receivers_all)))
  expect_equal(names(receivers_all), names(receivers_receiver1))
  expect_equal(names(receivers_all), names(receivers_receiver_multiple))
})

testthat::test_that("Test number of records", {
  expect_gt(nrow(receivers_all), nrow(receivers_receiver1))
  expect_equal(nrow(receivers_receiver1), 1)
  expect_equal(nrow(receivers_receiver_multiple), 2)
})

testthat::test_that("Test if data is filtered on paramater", {
  expect_equal(
    receivers_receiver1 %>% distinct(receiver_id) %>% pull(),
    c(receiver1)
  )
  expect_equal(
    receivers_receiver_multiple %>% distinct(receiver_id) %>% arrange(receiver_id) %>% pull(),
    receiver_multiple
  )
})

testthat::test_that("Test unique ids", {
  expect_equal(nrow(receivers_all), nrow(receivers_all %>% distinct(pk)))
  expect_equal(nrow(receivers_all), nrow(receivers_all %>% distinct(receiver_id)))
})
