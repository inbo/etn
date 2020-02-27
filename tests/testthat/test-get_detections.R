con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_detections <- c(
  "pk",
  "date_time",
  "receiver_id",
  "application_type",
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
station_name <- "R03"
animal_project <- "phd_reubens"
network_project <- "thornton"
tag_id <- "A69-1303-65302"
receiver_id <- "VR2W-122360"
sciname <- "Anguilla anguilla"

detections_limit <- get_detections(con, limit = TRUE)
detections_start_end <- get_detections(
  con,
  animal_project_code = animal_project, network_project_code = network_project,
  start_date = start_date, end_date = end_date, tag_id = tag_id, limit = FALSE
)
detections_station <- get_detections(
  con,
  animal_project_code = animal_project, network_project_code = network_project,
  station_name = station_name, tag_id = tag_id, limit = FALSE
)
detections_tag <- get_detections(con, tag_id = tag_id, limit = TRUE)
detections_receiver <- get_detections(con, receiver_id = receiver_id, limit = TRUE)
detections_sciname <- get_detections(con, scientific_name = sciname, limit = TRUE)

testthat::test_that("Test input", {
  expect_error(
    get_detections("not_a_connection"),
    "Not a connection object to database."
  )
  expect_error(
    get_detections(con, network_project_code = "not_a_project")
  )
  expect_error(
    get_detections(con, network_project_code = c("thornton", "not_a_project"))
  )
  expect_error(
    get_detections(con, animal_project_code = "not_a_project", network_project_code = "thornton")
  )
  expect_error(
    get_detections(con, animal_project_code = c("phd_reubens", "not_a_project"), network_project_code = "thornton")
  )
  expect_error(
    get_detections(con, animal_project_code = "phd_reubens", network_project_code = "thornton", start_date = "not_a_date")
  )
  expect_error(
    get_detections(con, animal_project_code = "phd_reubens", network_project_code = "thornton", start_date = "2011", end_date = "not_a_date")
  )
  expect_error(
    get_detections(con, animal_project_code = "phd_reubens", network_project_code = "thornton", station_name = "not_a_station")
  )
  expect_error(
    get_detections(con, animal_project_code = "phd_reubens", network_project_code = "thornton", station_name = c("R03", "not_a_station"))
  )
  expect_error(
    get_detections(con, animal_project_code = "phd_reubens", network_project_code = "thornton", tag_id = c("R03", "not_a_tag"))
  )
  expect_error(
    get_detections(con, animal_project_code = "phd_reubens", network_project_code = "thornton", receiver_id = c("not_a_receiver"))
  )
  expect_error(
    get_detections(con, scientific_name = c("not_a_sciname"))
  )
})

testthat::test_that("Test output type", {
  expect_is(detections_limit, "data.frame")
  expect_is(detections_start_end, "data.frame")
  expect_is(detections_station, "data.frame")
  expect_is(detections_tag, "data.frame")
  expect_is(detections_receiver, "data.frame")
  expect_is(detections_sciname, "data.frame")
})

testthat::test_that("Test column names", {
  expect_true(all(names(detections_limit) %in% expected_col_names_detections))
  expect_true(all(expected_col_names_detections %in% names(detections_limit)))
  expect_equal(names(detections_limit), names(detections_start_end))
  expect_equal(names(detections_limit), names(detections_station))
  expect_equal(names(detections_limit), names(detections_tag))
  expect_equal(names(detections_limit), names(detections_receiver))
  expect_equal(names(detections_limit), names(detections_sciname))
})

testthat::test_that("Test number of records", {
  expect_equal(nrow(detections_limit), 100)
  expect_gt(nrow(detections_start_end), nrow(detections_limit))
  expect_gt(nrow(detections_station), nrow(detections_limit))
  expect_lte(nrow(detections_tag), nrow(detections_limit))
  expect_lte(nrow(detections_receiver), nrow(detections_limit))
  expect_lte(nrow(detections_sciname), nrow(detections_limit))
})

testthat::test_that("Test date range", {
  expect_gte(
    detections_start_end %>% summarize(min_date_time = min(date_time)) %>% pull(min_date_time),
    start_date_full
  )
  expect_lte(
    detections_start_end %>% summarize(max_date_time = max(date_time)) %>% pull(max_date_time),
    end_date_full
  )
})

testthat::test_that("Test if data is filtered on paramater", {
  expect_equal(
    detections_start_end %>% distinct(animal_project_code) %>% pull(),
    c(animal_project)
  )
  expect_equal(
    detections_start_end %>% distinct(network_project_code) %>% pull(),
    c(network_project)
  )
  expect_equal(
    detections_start_end %>% distinct(tag_id) %>% pull(),
    c(tag_id)
  )
  expect_equal(
    detections_station %>% distinct(animal_project_code) %>% pull(),
    c(animal_project)
  )
  expect_equal(
    detections_station %>% distinct(network_project_code) %>% pull(),
    c(network_project)
  )
  expect_equal(
    detections_station %>% distinct(tag_id) %>% pull(),
    c(tag_id)
  )
  expect_equal(
    detections_station %>% distinct(station_name) %>% pull(),
    c(station_name)
  )
  expect_equal(
    detections_tag %>% distinct(tag_id) %>% pull(),
    c(tag_id)
  )
  expect_equal(
    detections_receiver %>% distinct(receiver_id) %>% pull(),
    c(receiver_id)
  )
  expect_equal(
    detections_sciname %>% distinct(scientific_name) %>% pull(),
    c(sciname)
  )
})
