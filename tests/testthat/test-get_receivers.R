con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names <- c(
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
application1 <- "cpod"
status1 <- "Broken"
status_multiple <- c("Broken", "Lost")

receivers_all <- get_receivers(con)
receivers_receiver1 <- get_receivers(con, receiver_id = receiver1)
receivers_receiver_multiple <- get_receivers(con, receiver_id = receiver_multiple)
receivers_application1 <- get_receivers(con, application_type = application1)
receivers_status1 <- get_receivers(con, status = status1)
receivers_status_multiple <- get_receivers(con, status = status_multiple)

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
  expect_error(
    get_receivers(con, application_type = "not_an_application_type")
  )
  expect_error(
    get_receivers(con, status = "not_a_status")
  )
  expect_error(
    get_receivers(con, status = c("Broken", "not_a_status"))
  )
})

testthat::test_that("Test output type", {
  expect_is(receivers_all, "tbl_df")
  expect_is(receivers_receiver1, "tbl_df")
  expect_is(receivers_receiver_multiple, "tbl_df")
  expect_is(receivers_application1, "tbl_df")
  expect_is(receivers_status1, "tbl_df")
  expect_is(receivers_status_multiple, "tbl_df")
})

testthat::test_that("Test column names", {
  expect_equal(names(receivers_all), expected_col_names)
  expect_equal(names(receivers_receiver1), expected_col_names)
  expect_equal(names(receivers_receiver_multiple), expected_col_names)
  expect_equal(names(receivers_application1), expected_col_names)
  expect_equal(names(receivers_status1), expected_col_names)
  expect_equal(names(receivers_status_multiple), expected_col_names)
})

testthat::test_that("Test number of records", {
  expect_gt(nrow(receivers_all), nrow(receivers_receiver1))
  expect_equal(nrow(receivers_receiver1), 1)
  expect_equal(nrow(receivers_receiver_multiple), 2)
  expect_gt(nrow(receivers_all), nrow(receivers_application1))
  expect_gt(nrow(receivers_all), nrow(receivers_status1))
  expect_gte(nrow(receivers_status_multiple), nrow(receivers_status1))
})

testthat::test_that("Test if data is filtered on parameter", {
  expect_equal(
    receivers_receiver1 %>% distinct(receiver_id) %>% pull(),
    c(receiver1)
  )
  expect_equal(
    receivers_receiver_multiple %>% distinct(receiver_id) %>% arrange(receiver_id) %>% pull(),
    receiver_multiple
  )
  expect_equal(
    receivers_application1 %>% distinct(application_type) %>% pull(),
    application1
  )
  expect_equal(
    receivers_status1 %>% distinct(status) %>% pull(),
    c(status1)
  )
  expect_equal(
    receivers_status_multiple %>% distinct(status) %>% arrange(status) %>% pull(),
    status_multiple
  )
})

testthat::test_that("Test unique ids", {
  expect_equal(nrow(receivers_all), nrow(receivers_all %>% distinct(pk)))
  expect_equal(nrow(receivers_all), nrow(receivers_all %>% distinct(receiver_id)))
})
