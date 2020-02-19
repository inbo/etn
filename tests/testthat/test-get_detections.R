# Connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_detections <- c(
  "receiver",
  "transmitter",
  "transmitter_name",
  "transmitter_serial",
  "sensor_value",
  "sensor_unit",
  "sensor2_value",
  "sensor2_unit",
  "station_name",
  "datetime",
  "id_pk",
  "qc_flag",
  "file","latitude",
  "longitude",
  "deployment_fk",
  "scientific_name",
  "location_name",
  "deployment_station_name",
  "deploy_date_time",
  "animal_project_name",
  "animal_project_code",
  "animal_moratorium",
  "network_project_name",
  "network_project_code",
  "network_moratorium",
  "signal_to_noise_ratio",
  "detection_file_id",
  "tag_sensor_type",
  "tag_intercept",
  "tag_slope",
  "sensor_value_depth_meters",
  "tag_owner_organization",
  "animal_id_pk",
  "animal_common_name",
  "animal_sex",
  "deployment_lat",
  "deployment_long",
  "sensor_value_acceleration"
)

start_date <- "2011"
end_date <- "2011-02-01"
start <- check_datetime(start_date, "start_date")
end <- check_datetime(end_date, "end_date")
limit <- 5
animal_project <- "phd_reubens"
network_project <- "thornton"
transmitter <- "A69-1303-65302"
receiver <- "VR2W-122360"
scientific_name <- "Anguilla anguilla"
deployment_station_name <- "R03"

detections_limit5 <- get_detections(con, start_date = start_date, limit = 5)
detections_start_end <- get_detections(con, animal_project = animal_project,
                       network_project = network_project, start_date = start_date,
                       end_date = end_date, limit = limit,
                       transmitter = transmitter)
detections_station <- get_detections(con, animal_project = animal_project,
                        network_project = network_project,
                        deployment_station_name = deployment_station_name,
                        limit = limit, transmitter = transmitter)

detections_transmitter <- get_detections(con, transmitter = transmitter, limit = limit)
detections_receiver <- get_detections(con, receiver = receiver, limit = limit)
detections_name <- get_detections(con, scientific_name = scientific_name, limit = limit)

testthat::test_that("test_input_get_detections", {
  expect_error(get_detections("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_detections(con, network_project = "very_bad_project"))
  expect_error(get_detections(con, network_project = c("thornton",
                                                      "very_bad_project")))
  expect_error(get_detections(con, animal_project = "very_bad_project",
                              network_project = "thornton"))
  expect_error(get_detections(con,
                              animal_project = c("phd_reubens", "i_am_bad"),
                              network_project = "thornton"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              start_date = "bad_date"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              start_date = "2011", end_date = "bad_brrrr"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              start_date = "2011", end_date = "bad_brrrr"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              deployment_station_name = "no_way"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              deployment_station_name = c("R03","no_way")))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              transmitter = c("R03","no_way")))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              receiver = c("superraar")))
  expect_error(get_detections(con, scientific_name = c("I am not an animal")))
})

testthat::test_that("test_output_get_detections", {
  library(dplyr)
  expect_is(detections_limit5, "data.frame")
  expect_is(detections_start_end, "data.frame")
  expect_is(detections_station, "data.frame")
  expect_is(detections_transmitter, "data.frame")
  expect_true(all(names(detections_limit5) %in% expected_col_names_detections))
  expect_true(all(expected_col_names_detections %in% names(detections_limit5)))
  expect_equal(nrow(detections_limit5), 5)
  expect_equal(names(detections_limit5), names(detections_start_end))
  expect_equal(names(detections_limit5), names(detections_station))
  expect_equal(names(detections_limit5), names(detections_transmitter))
  expect_equal(names(detections_limit5), names(detections_receiver))
  expect_equal(names(detections_limit5), names(detections_name))
  expect_true(detections_limit5 %>%
                 select(datetime) %>%
                 summarize(min_datetime = min(datetime)) %>%
                 pull(min_datetime) > start)
  expect_true(detections_start_end %>%
                select(datetime) %>%
                summarize(min_datetime = min(datetime)) %>%
                pull(min_datetime) > start)
  expect_true(detections_start_end %>%
                select(datetime) %>%
                summarize(max_datetime = max(datetime)) %>%
                pull(max_datetime) < end)
  expect_true(detections_start_end %>%
                distinct(animal_project_code) %>%
                pull() == animal_project)
  expect_true(detections_start_end %>%
                distinct(network_project_code) %>%
                pull() == network_project)
  expect_lte(detections_start_end %>% nrow(), limit)
  expect_true(detections_station %>%
                distinct(deployment_station_name) %>%
                pull() == deployment_station_name)
  expect_true(detections_transmitter %>%
                distinct(transmitter) %>%
                pull() == transmitter)
  expect_true(detections_receiver %>%
                distinct(receiver) %>%
                pull() == receiver)
  expect_true(detections_name %>%
                distinct(scientific_name) %>%
                pull() == scientific_name)
})
