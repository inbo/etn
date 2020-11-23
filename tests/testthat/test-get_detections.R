con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names <- c(
  "pk",
  "date_time",
  "receiver_id",
  "application_type",
  "network_project_code",
  "tag_id",
  "tag_fk",
  "animal_id",
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

application1 <- "acoustic_telemetry" # No "cpod" data at time of writing
start_date1 <- "2016"
end_date1 <- "2016-06-18"
start_date1_full <- as.POSIXct(check_date_time(start_date1, "start_date1"), tz = "UTC")
end_date1_full <- as.POSIXct(check_date_time(end_date1, "end_date1"), tz = "UTC")
station1 <- "s-6"
animal_project1 <- "2014_demer"
network_project1 <- "zeeschelde"
tag1 <- "A69-1601-26530"
receiver1 <- "VR2W-112286"
sciname1 <- "Silurus glanis"

detections_limit <- get_detections(con, limit = TRUE)
detections_application1 <- get_detections(
  con, application_type = application1, limit = TRUE
)
detections_start_end1 <- get_detections(
  con,
  animal_project_code = animal_project1, network_project_code = network_project1,
  start_date = start_date1, end_date = end_date1, tag_id = tag1
)
detections_station1 <- get_detections(
  con,
  animal_project_code = animal_project1, network_project_code = network_project1,
  station_name = station1
)
detections_tag1 <- get_detections(con, tag_id = tag1, limit = TRUE)
detections_receiver1 <- get_detections(con, receiver_id = receiver1, limit = TRUE)
detections_sciname1 <- get_detections(con, scientific_name = sciname1, limit = TRUE)

testthat::test_that("Test input", {
  expect_error(
    get_detections("not_a_connection"),
    "Not a connection object to database."
  )
  expect_error(
    get_detections(con, application_type = "not_an_application_type")
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
  expect_is(detections_limit, "tbl_df")
  expect_is(detections_application1, "tbl_df")
  expect_is(detections_start_end1, "tbl_df")
  expect_is(detections_station1, "tbl_df")
  expect_is(detections_tag1, "tbl_df")
  expect_is(detections_receiver1, "tbl_df")
  expect_is(detections_sciname1, "tbl_df")
})

testthat::test_that("Test column names", {
  expect_equal(names(detections_limit), expected_col_names)
  expect_equal(names(detections_application1), expected_col_names)
  expect_equal(names(detections_start_end1), expected_col_names)
  expect_equal(names(detections_station1), expected_col_names)
  expect_equal(names(detections_tag1), expected_col_names)
  expect_equal(names(detections_receiver1), expected_col_names)
  expect_equal(names(detections_sciname1), expected_col_names)
})

testthat::test_that("Test number of records", {
  expect_equal(nrow(detections_limit), 100)
  expect_equal(nrow(detections_limit), nrow(detections_application1))
  expect_lt(nrow(detections_limit), nrow(detections_start_end1))
  expect_lt(nrow(detections_limit), nrow(detections_station1))
  expect_gte(nrow(detections_limit), nrow(detections_tag1))
  expect_gte(nrow(detections_limit), nrow(detections_receiver1))
  expect_gte(nrow(detections_limit), nrow(detections_sciname1))
})

testthat::test_that("Test date range", {
  expect_gte(
    detections_start_end1 %>% summarize(min_date_time = min(date_time)) %>% pull(min_date_time),
    start_date1_full
  )
  expect_lte(
    detections_start_end1 %>% summarize(max_date_time = max(date_time)) %>% pull(max_date_time),
    end_date1_full
  )
})

testthat::test_that("Test if data is filtered on parameter", {
  expect_equal(
    detections_application1 %>% distinct(application_type) %>% pull(),
    c(application1)
  )
  expect_equal(
    detections_start_end1 %>% distinct(animal_project_code) %>% pull(),
    c(animal_project1)
  )
  expect_equal(
    detections_start_end1 %>% distinct(network_project_code) %>% pull(),
    c(network_project1)
  )
  expect_equal(
    detections_start_end1 %>% distinct(tag_id) %>% pull(),
    c(tag1)
  )
  expect_equal(
    detections_station1 %>% distinct(animal_project_code) %>% pull(),
    c(animal_project1)
  )
  expect_equal(
    detections_station1 %>% distinct(network_project_code) %>% pull(),
    c(network_project1)
  )
  expect_equal(
    detections_station1 %>% distinct(station_name) %>% pull(),
    c(station1)
  )
  expect_equal(
    detections_tag1 %>% distinct(tag_id) %>% pull(),
    c(tag1)
  )
  expect_equal(
    detections_receiver1 %>% distinct(receiver_id) %>% pull(),
    c(receiver1)
  )
  expect_equal(
    detections_sciname1 %>% distinct(scientific_name) %>% pull(),
    c(sciname1)
  )
})
