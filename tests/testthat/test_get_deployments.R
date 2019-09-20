context("test_get_deployments")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# valid column names
valid_col_names_deployments <- c(
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
test1 <- get_deployments(con)
test2 <- get_deployments(con, network_project = "thornton")
test3 <- get_deployments(con, network_project = c("thornton",
                                                  "leopold"))
test4 <- get_deployments(con, receiver_status = "Broken")
test5 <- get_deployments(con, receiver_status = c("Broken", "Lost"))
test6 <- get_deployments(con, network_project = "thornton",
                         open_only = FALSE)

testthat::test_that("test_input_get_deployments", {
  expect_error(get_transmitters("I am not a connection"),
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
  expect_is(test1, "data.frame")
  expect_is(test2, "data.frame")
  expect_is(test3, "data.frame")
  expect_true(all(names(test1) %in% valid_col_names_deployments))
  expect_true(all(valid_col_names_deployments %in% names(test1)))
  expect_gte(nrow(test1), nrow(test2))
  expect_gte(nrow(test1), nrow(test3))
  expect_gte(nrow(test3), nrow(test2))
  expect_gte(nrow(test5), nrow(test4))
  expect_equal(names(test1), names(test2))
  expect_equal(names(test1), names(test3))
  expect_equal(names(test1), names(test4))
  expect_equal(names(test1), names(test5))
  expect_equal(names(test1), names(test6))
  expect_gte(test1 %>% distinct(receiver_status) %>% nrow(),
             test2 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test3 %>% distinct(receiver_status) %>% nrow(),
             test2 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test1 %>% distinct(receiver_status) %>% nrow(),
             test3 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test1 %>% distinct(receiver_status) %>% nrow(),
             test5 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test5 %>% distinct(receiver_status) %>% nrow(),
             test4 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test6 %>% nrow(),
             test2 %>% nrow())
  expect_gte(test1 %>% distinct(projectcode) %>% nrow(),
             test2 %>% distinct(projectcode) %>% nrow())
  expect_gte(test3 %>% distinct(projectcode) %>% nrow(),
             test2 %>% distinct(projectcode) %>% nrow())
  expect_gte(test1 %>% distinct(projectcode) %>% nrow(),
             test5 %>% distinct(projectcode) %>% nrow())
  expect_gte(test5 %>% distinct(projectcode) %>% nrow(),
             test4 %>% distinct(projectcode) %>% nrow())
  expect_true(test2 %>% distinct(projectcode) %>% pull() == "thornton")
  expect_true(all(test3 %>% distinct(projectcode) %>% pull() %in% c("thornton",
                                                                  "leopold")))
  expect_true(all(test2 %>% distinct(receiver_status) %>% pull() %in%
                    (test3 %>% distinct(receiver_status) %>% pull())))
  expect_true(all(test3 %>% distinct(receiver_status) %>% pull() %in%
                    (test1 %>% distinct(receiver_status) %>% pull())))
  expect_true(test4 %>% distinct(receiver_status) %>% pull() == "Broken")
  expect_true(all(test5 %>% distinct(receiver_status) %>% pull() %in% c("Broken",
                                                                  "Lost")))
  expect_true(all(test2 %>% select(recover_date_time) %>% is.na()))
  # excluding outside function is the same as conditional TRUE
  expect_equal(nrow(test6 %>% filter(is.na(recover_date_time))), nrow(test2))
})
