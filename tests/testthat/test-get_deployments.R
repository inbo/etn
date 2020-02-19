# Connection
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

deployments_all <- get_deployments(con)
deployments_project1 <- get_deployments(con, network_project = "thornton")
deployments_projects_multiple <- get_deployments(con, network_project = c("thornton",
                                                  "leopold"))
deployments_status1 <- get_deployments(con, receiver_status = "Broken")
deployments_status_multiple <- get_deployments(con, receiver_status = c("Broken", "Lost"))
deployments_project1_openfalse <- get_deployments(con, network_project = "thornton",
                         open_only = FALSE)

testthat::test_that("test_input_get_deployments", {
  expect_error(get_deployments("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_deployments(con, network_project = "very_bad_project"))
  expect_error(get_deployments(con, network_project = c("thornton",
                                                        "very_bad_project")))
  expect_error(get_deployments(con, network_project = "thornton",
                               receiver_status = "very_bad_receiver_status"))
  expect_error(get_deployments(con, network_project = "thornton",
                               receiver_status = c("Broken",
                                                   "very_bad_receiver_status")))
})


testthat::test_that("test_output_get_deployments", {
  library(dplyr)
  expect_is(deployments_all, "data.frame")
  expect_is(deployments_project1, "data.frame")
  expect_is(deployments_projects_multiple, "data.frame")
  expect_true(all(names(deployments_all) %in% expected_col_names_deployments))
  expect_true(all(expected_col_names_deployments %in% names(deployments_all)))
  expect_gte(nrow(deployments_all), nrow(deployments_project1))
  expect_gte(nrow(deployments_all), nrow(deployments_projects_multiple))
  expect_gte(nrow(deployments_projects_multiple), nrow(deployments_project1))
  expect_gte(nrow(deployments_status_multiple), nrow(deployments_status1))
  expect_equal(names(deployments_all), names(deployments_project1))
  expect_equal(names(deployments_all), names(deployments_projects_multiple))
  expect_equal(names(deployments_all), names(deployments_status1))
  expect_equal(names(deployments_all), names(deployments_status_multiple))
  expect_equal(names(deployments_all), names(deployments_project1_openfalse))
  expect_gte(deployments_all %>% distinct(receiver_status) %>% nrow(),
             deployments_project1 %>% distinct(receiver_status) %>% nrow())
  expect_gte(deployments_projects_multiple %>% distinct(receiver_status) %>% nrow(),
             deployments_project1 %>% distinct(receiver_status) %>% nrow())
  expect_gte(deployments_all %>% distinct(receiver_status) %>% nrow(),
             deployments_projects_multiple %>% distinct(receiver_status) %>% nrow())
  expect_gte(deployments_all %>% distinct(receiver_status) %>% nrow(),
             deployments_status_multiple %>% distinct(receiver_status) %>% nrow())
  expect_gte(deployments_status_multiple %>% distinct(receiver_status) %>% nrow(),
             deployments_status1 %>% distinct(receiver_status) %>% nrow())
  expect_gte(deployments_project1_openfalse %>% nrow(),
             deployments_project1 %>% nrow())
  expect_gte(deployments_all %>% distinct(network_project_code) %>% nrow(),
             deployments_project1 %>% distinct(network_project_code) %>% nrow())
  expect_gte(deployments_projects_multiple %>% distinct(network_project_code) %>% nrow(),
             deployments_project1 %>% distinct(network_project_code) %>% nrow())
  expect_gte(deployments_all %>% distinct(network_project_code) %>% nrow(),
             deployments_status_multiple %>% distinct(network_project_code) %>% nrow())
  expect_gte(deployments_status_multiple %>% distinct(network_project_code) %>% nrow(),
             deployments_status1 %>% distinct(network_project_code) %>% nrow())
  expect_true(deployments_project1 %>% distinct(network_project_code) %>% pull() == "thornton")
  expect_true(all(deployments_projects_multiple %>% distinct(network_project_code) %>% pull() %in% c("thornton",
                                                                  "leopold")))
  expect_true(all(deployments_project1 %>% distinct(receiver_status) %>% pull() %in%
                    (deployments_projects_multiple %>% distinct(receiver_status) %>% pull())))
  expect_true(all(deployments_projects_multiple %>% distinct(receiver_status) %>% pull() %in%
                    (deployments_all %>% distinct(receiver_status) %>% pull())))
  expect_true(deployments_status1 %>% distinct(receiver_status) %>% pull() == "Broken")
  expect_true(all(deployments_status_multiple %>% distinct(receiver_status) %>% pull() %in% c("Broken",
                                                                  "Lost")))
  expect_true(all(deployments_project1 %>% select(recover_date_time) %>% is.na()))
  # excluding outside function is the same as conditional TRUE
  expect_equal(nrow(deployments_project1_openfalse %>% filter(is.na(recover_date_time))), nrow(deployments_project1))
})
