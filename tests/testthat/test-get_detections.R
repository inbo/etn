# Connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_detections <- c(
  "pk",
  "date_time",
  "receiver_id",
  "network_project_code",
  "tag_id",
  "tag_fk",
  "animal_id",
  "animal_fk",
  "animal_project_code",
  "scientific_name",
  "station_name",
  "deploy_latitude",
  "deploy_longitude",
  "sensor_type",
  "sensor_value",
  "sensor_unit",
  "sensor_value_depth",
  "sensor_value_acceleration",
  "sensor_value_temperature",
  "signal_to_noise_ratio",
  "source_file",
  "qc_flag",
  "deployment_fk"
)

start_date <- "2011"
end_date <- "2011-02-01"
start <- check_date_time(start_date, "start_date")
end <- check_date_time(end_date, "end_date")
limit <- 5
animal_project <- "phd_reubens"
network_project <- "thornton"
tag_id <- "A69-1303-65302"
receiver_id <- "VR2W-122360"
scientific_name <- "Anguilla anguilla"
station_name <- "R03"

detections_limit5 <- get_detections(con, start_date = start_date, limit = 5)
detections_start_end <- get_detections(con, animal_project = animal_project,
                       network_project = network_project, start_date = start_date,
                       end_date = end_date, limit = limit,
                       tag_id = tag_id)
detections_station <- get_detections(con, animal_project = animal_project,
                        network_project = network_project,
                        station_name = station_name,
                        limit = limit, tag_id = tag_id)

detections_tag <- get_detections(con, tag_id = tag_id, limit = limit)
# detections_receiver <- get_detections(con, receiver_id = receiver_id, limit = limit)
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
                              station_name = "no_way"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              station_name = c("R03","no_way")))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              tag_id = c("R03","no_way")))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              receiver_id = c("superraar")))
  expect_error(get_detections(con, scientific_name = c("I am not an animal")))
})

testthat::test_that("test_output_get_detections", {
  library(dplyr)
  expect_is(detections_limit5, "data.frame")
  expect_is(detections_start_end, "data.frame")
  expect_is(detections_station, "data.frame")
  expect_is(detections_tag, "data.frame")
  expect_true(all(names(detections_limit5) %in% expected_col_names_detections))
  expect_true(all(expected_col_names_detections %in% names(detections_limit5)))
  expect_equal(nrow(detections_limit5), 5)
  expect_equal(names(detections_limit5), names(detections_start_end))
  expect_equal(names(detections_limit5), names(detections_station))
  expect_equal(names(detections_limit5), names(detections_tag))
#  expect_equal(names(detections_limit5), names(detections_receiver))
  expect_equal(names(detections_limit5), names(detections_name))
  expect_true(detections_limit5 %>%
                 select(date_time) %>%
                 summarize(min_date_time = min(date_time)) %>%
                 pull(min_date_time) > start)
  expect_true(detections_start_end %>%
                select(date_time) %>%
                summarize(min_date_time = min(date_time)) %>%
                pull(min_date_time) > start)
  expect_true(detections_start_end %>%
                select(date_time) %>%
                summarize(max_date_time = max(date_time)) %>%
                pull(max_date_time) < end)
  expect_true(detections_start_end %>%
                distinct(animal_project_code) %>%
                pull() == animal_project)
  expect_true(detections_start_end %>%
                distinct(network_project_code) %>%
                pull() == network_project)
  expect_lte(detections_start_end %>% nrow(), limit)
  expect_true(detections_station %>%
                distinct(station_name) %>%
                pull() == station_name)
  expect_true(detections_tag %>%
                distinct(tag_id) %>%
                pull() == tag_id)
#  expect_true(detections_receiver %>%
#                distinct(receiver_id) %>%
#                pull() == receiver_id)
  expect_true(detections_name %>%
                distinct(scientific_name) %>%
                pull() == scientific_name)
})
