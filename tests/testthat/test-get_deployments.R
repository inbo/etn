# Connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_deployments <- c(
  "receiver",
  "receiver_status",
  "projectname",
  "projectcode",
  "projectmember",
  "drop_dead_date",
  "download_date_time",
  "deploy_date_time",
  "recover_date_time",
  "bottom_depth",
  "riser_length",
  "instrument_depth",
  "check_complete_time",
  "sync_date_time",
  "voltage_at_deploy",
  "ar_confirm",
  "data_downloaded",
  "voltage_at_download",
  "time_drift",
  "comments",
  "id_pk",
  "receiver_fk",
  "location_name",
  "location_manager",
  "location_description",
  "deploy_lat",
  "deploy_long",
  "recover_lat",
  "recover_long",
  "station_name",
  "intended_lat",
  "intended_long",
  "date_created",
  "date_modified",
  "battery_install_date",
  "ar_battery_install_date",
  "distance_to_mouth",
  "source",
  "transmit_profile",
  "transmit_power_output",
  "log_temperature_stats_period",
  "log_temperature_sample_period",
  "log_tilt_sample_period",
  "log_noise_stats_period",
  "log_noise_sample_period",
  "log_depth_stats_period",
  "log_depth_sample_period",
  "project_fk",
  "mooring_type",
  "deployment_type",
  "activation_datetime",
  "valid_data_until_datetime"
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
  expect_gte(deployments_all %>% distinct(projectcode) %>% nrow(),
             deployments_project1 %>% distinct(projectcode) %>% nrow())
  expect_gte(deployments_projects_multiple %>% distinct(projectcode) %>% nrow(),
             deployments_project1 %>% distinct(projectcode) %>% nrow())
  expect_gte(deployments_all %>% distinct(projectcode) %>% nrow(),
             deployments_status_multiple %>% distinct(projectcode) %>% nrow())
  expect_gte(deployments_status_multiple %>% distinct(projectcode) %>% nrow(),
             deployments_status1 %>% distinct(projectcode) %>% nrow())
  expect_true(deployments_project1 %>% distinct(projectcode) %>% pull() == "thornton")
  expect_true(all(deployments_projects_multiple %>% distinct(projectcode) %>% pull() %in% c("thornton",
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
