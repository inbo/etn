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
start_date_full <- as.POSIXct(check_date_time(start_date, "start_date"), tz = "UTC")
end_date_full <- as.POSIXct(check_date_time(end_date, "end_date"), tz = "UTC")
animal_project <- "phd_reubens"
network_project <- "thornton"
tag_id <- "A69-1303-65302"
receiver_id <- "VR2W-122360"
scientific_name <- "Anguilla anguilla"
station_name <- "R03"

detections_limit <- get_detections(
  con,
  start_date = start_date,
  limit = TRUE
)
detections_start_end <- get_detections(
  con,
  animal_project_code = animal_project,
  network_project_code = network_project,
  start_date = start_date,
  end_date = end_date,
  tag_id = tag_id,
  limit = FALSE
)
detections_station <- get_detections(
  con,
  animal_project_code = animal_project,
  network_project_code = network_project,
  station_name = station_name,
  tag_id = tag_id,
  limit = FALSE
)
detections_tag <- get_detections(
  con,
  tag_id = tag_id,
  limit = TRUE
)
detections_receiver <- get_detections(
  con,
  receiver_id = receiver_id,
  limit = TRUE
)
detections_name <- get_detections(
  con,
  scientific_name = scientific_name,
  limit = TRUE
)

testthat::test_that("test_input_get_detections", {
  expect_error(get_detections("I am not a connection"),
    "Not a connection object to database."
  )
  expect_error(get_detections(
    con,
    network_project_code = "very_bad_project"
  ))
  expect_error(get_detections(
    con,
    network_project_code = c("thornton", "very_bad_project")
  ))
  expect_error(get_detections(
    con,
    animal_project_code = "very_bad_project",
    network_project_code = "thornton"
  ))
  expect_error(get_detections(
    con,
    animal_project_code = c("phd_reubens", "i_am_bad"),
    network_project_code = "thornton"
  ))
  expect_error(get_detections(
    con,
    animal_project_code = "phd_reubens",
    network_project_code = "thornton",
    start_date = "bad_date"
  ))
  expect_error(get_detections(
    con,
    animal_project_code = "phd_reubens",
    network_project_code = "thornton",
    start_date = "2011",
    end_date = "bad_brrrr"
  ))
  expect_error(get_detections(
    con,
    animal_project_code = "phd_reubens",
    network_project_code = "thornton",
    start_date = "2011",
    end_date = "bad_brrrr"
  ))
  expect_error(get_detections(
    con,
    animal_project_code = "phd_reubens",
    network_project_code = "thornton",
    station_name = "no_way"
  ))
  expect_error(get_detections(
    con,
    animal_project_code = "phd_reubens",
    network_project_code = "thornton",
    station_name = c("R03", "no_way")
  ))
  expect_error(get_detections(
    con,
    animal_project_code = "phd_reubens",
    network_project_code = "thornton",
    tag_id = c("R03", "no_way")
  ))
  expect_error(get_detections(
    con,
    animal_project_code = "phd_reubens",
    network_project_code = "thornton",
    receiver_id = c("superraar")
  ))
  expect_error(get_detections(
    con,
    scientific_name = c("I am not an animal")
  ))
})

testthat::test_that("test_output_get_detections", {
  # Output type
  expect_is(detections_limit, "data.frame")
  expect_is(detections_start_end, "data.frame")
  expect_is(detections_station, "data.frame")
  expect_is(detections_tag, "data.frame")
  expect_is(detections_name, "data.frame")

  # Col names
  expect_true(all(names(detections_limit) %in% expected_col_names_detections))
  expect_true(all(expected_col_names_detections %in% names(detections_limit)))
  expect_equal(names(detections_limit), names(detections_start_end))
  expect_equal(names(detections_limit), names(detections_station))
  expect_equal(names(detections_limit), names(detections_tag))
  expect_equal(names(detections_limit), names(detections_receiver))
  expect_equal(names(detections_limit), names(detections_name))

  # Number of records
  expect_equal(nrow(detections_limit), 100)
  expect_gte(nrow(detections_start_end), nrow(detections_limit))
  expect_gte(nrow(detections_station), nrow(detections_limit))
  expect_lte(nrow(detections_tag), nrow(detections_limit))
  expect_lte(nrow(detections_receiver), nrow(detections_limit))
  expect_lte(nrow(detections_name), nrow(detections_limit))

  # Minimum date in data >= start_date
  expect_gte(detections_limit %>%
    summarize(min_date_time = min(date_time)) %>%
    pull(min_date_time), start_date_full)
  expect_gte(detections_start_end %>%
    summarize(min_date_time = min(date_time)) %>%
    pull(min_date_time), start_date_full)

  # Maximum date in data <= end_date
  expect_lte(detections_start_end %>%
    summarize(max_date_time = max(date_time)) %>%
    pull(max_date_time), end_date_full)

  # Selected parameter can be found in data
  expect_true(detections_start_end %>%
    distinct(animal_project_code) %>%
    pull() == animal_project)
  expect_true(detections_start_end %>%
    distinct(network_project_code) %>%
    pull() == network_project)
  expect_true(detections_station %>%
    distinct(station_name) %>%
    pull() == station_name)
  expect_true(detections_tag %>%
    distinct(tag_id) %>%
    pull() == tag_id)
  expect_true(detections_receiver %>%
    distinct(receiver_id) %>%
    pull() == receiver_id)
  expect_true(detections_name %>%
    distinct(scientific_name) %>%
    pull() == scientific_name)
})
