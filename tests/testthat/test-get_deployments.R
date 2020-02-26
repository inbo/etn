con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_deployments <- c(
  "pk",
  "receiver_id",
  "network_project_code",
  "station_name",
  "station_description",
  "station_manager",
  "deploy_date_time",
  "deploy_latitude",
  "deploy_longitude",
  "intended_latitude",
  "intended_longitude",
  "mooring_type",
  "bottom_depth",
  "riser_length",
  "deploy_depth",
  "battery_installation_date",
  "battery_estimated_end_date",
  "activation_date_time",
  "recover_date_time",
  "recover_latitude",
  "recover_longitude",
  "download_date_time",
  "download_file_name",
  "valid_data_until_date_time",
  "sync_date_time",
  "time_drift",
  "ar_battery_installation_date",
  "ar_confirm",
  "transmit_profile",
  "transmit_power_output",
  "log_temperature_stats_period",
  "log_temperature_sample_period",
  "log_tilt_sample_period",
  "log_noise_stats_period",
  "log_noise_sample_period",
  "log_depth_stats_period",
  "log_depth_sample_period",
  "comments",
  "receiver_status" # This field comes from join with receivers
)

project1 <- "ws1"
project_multiple <- c("ws1", "ws2")
status1 <- "Broken"
status_multiple <- c("Broken", "Lost")

deployments_all <- get_deployments(con)
deployments_project1 <- get_deployments(con, network_project_code = project1)
deployments_project_multiple <- get_deployments(con, network_project_code = project_multiple)
deployments_status1 <- get_deployments(con, receiver_status = status1)
deployments_status_multiple <- get_deployments(con, receiver_status = status_multiple)
deployments_project1_openfalse <- get_deployments(con, network_project_code = project1, open_only = FALSE)

testthat::test_that("Test input", {
  expect_error(
    get_deployments("not_a_connection"),
    "Not a connection object to database."
  )
  expect_error(
    get_deployments(con, network_project_code = "not_a_project")
  )
  expect_error(
    get_deployments(con, network_project_code = c("thornton", "not_a_project"))
  )
  expect_error(
    get_deployments(con, network_project_code = "thornton", receiver_status = "not_a_receiver_status")
  )
  expect_error(
    get_deployments(con, network_project_code = "thornton", receiver_status = c("Broken", "not_a_receiver_status"))
  )
})

testthat::test_that("Test output type", {
  expect_is(deployments_all, "data.frame")
  expect_is(deployments_project1, "data.frame")
  expect_is(deployments_project_multiple, "data.frame")
  expect_is(deployments_status1, "data.frame")
  expect_is(deployments_status_multiple, "data.frame")
  expect_is(deployments_project1_openfalse, "data.frame")
})

testthat::test_that("Test column names", {
  expect_true(all(names(deployments_all) %in% expected_col_names_deployments))
  expect_true(all(expected_col_names_deployments %in% names(deployments_all)))
  expect_equal(names(deployments_all), names(deployments_project1))
  expect_equal(names(deployments_all), names(deployments_project_multiple))
  expect_equal(names(deployments_all), names(deployments_status1))
  expect_equal(names(deployments_all), names(deployments_status_multiple))
  expect_equal(names(deployments_all), names(deployments_project1_openfalse))
})

testthat::test_that("Test number of records", {
  expect_gte(nrow(deployments_all), nrow(deployments_project1))
  expect_gte(nrow(deployments_all), nrow(deployments_project_multiple))
  expect_gte(nrow(deployments_project_multiple), nrow(deployments_project1))
  expect_gte(nrow(deployments_status_multiple), nrow(deployments_status1))
  expect_gte(nrow(deployments_project1_openfalse), nrow(deployments_project1))
})

testthat::test_that("Test if data is filtered on paramater", {
  expect_equal(
    deployments_project1 %>% distinct(network_project_code) %>% pull(),
    c(project1)
  )
  expect_equal(
    deployments_project_multiple %>% distinct(network_project_code) %>% arrange(network_project_code) %>% pull(),
    project_multiple
  )
  expect_equal(
    deployments_status1 %>% distinct(receiver_status) %>% pull(),
    c(status1)
  )
  expect_equal(
    deployments_status_multiple %>% distinct(receiver_status) %>% arrange(receiver_status) %>% pull(),
    status_multiple
  )
  expect_equal(
    deployments_project1_openfalse %>% distinct(network_project_code) %>% pull(),
    c(project1)
  )
})

testthat::test_that("Test open ended date", {
  expect_true(
    all(deployments_project1 %>% select(recover_date_time) %>% is.na())
  )
  expect_equal(
    nrow(deployments_project1_openfalse %>% filter(is.na(recover_date_time))),
    nrow(deployments_project1)
  )
})
