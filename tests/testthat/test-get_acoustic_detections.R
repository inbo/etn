con <- connect_to_etn()

test_that("get_acoustic_detections() returns error for incorrect connection", {
  expect_error(
    get_acoustic_detections(con = "not_a_connection"),
    "Not a connection object to database."
  )
})

test_that("get_acoustic_detections() returns a tibble", {
  df <- get_acoustic_detections(con, limit = TRUE)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_acoustic_detections() returns unique detection_id", {
  df <- get_acoustic_detections(con, limit = TRUE)
  expect_equal(nrow(df), nrow(df %>% distinct(detection_id)))
})

test_that("get_acoustic_detections() returns the expected columns", {
  df <- get_acoustic_detections(con, limit = TRUE)
  expected_col_names <- c(
    "detection_id",
    "date_time",
    "tag_serial_number",
    "acoustic_tag_id",
    "animal_project_code",
    "animal_id",
    "scientific_name",
    "acoustic_project_code",
    "receiver_id",
    "station_name",
    "deploy_latitude",
    "deploy_longitude",
    "sensor_value",
    "sensor_unit",
    "sensor2_value",
    "sensor2_unit",
    "signal_to_noise_ratio",
    "source_file",
    "qc_flag",
    "deployment_id"
  )
  expect_equal(names(df), expected_col_names)
})

test_that("get_acoustic_detections() allows selecting on start_date and end_date", {
  # Errors
  expect_error(get_acoustic_detections(con, start_date = "not_a_date"))
  expect_error(get_acoustic_detections(con, end_date = "not_a_date"))

  # 2014_demer contains data from 2014-04-18 15:45:00 UTC to 2018-09-15 19:40:51 UTC

  # Start date (inclusive) <= min(date_time)
  start_year_df <- get_acoustic_detections(con, start_date = "2015", animal_project_code = "2014_demer")
  expect_lte(as.POSIXct("2015-01-01", tz = "UTC"), min(start_year_df$date_time))
  start_month_df <- get_acoustic_detections(con, start_date = "2015-04", animal_project_code = "2014_demer")
  expect_lte(as.POSIXct("2015-04-01", tz = "UTC"), min(start_month_df$date_time))
  start_day_df <- get_acoustic_detections(con, start_date = "2015-04-24", animal_project_code = "2014_demer")
  expect_lte(as.POSIXct("2015-04-24", tz = "UTC"), min(start_day_df$date_time))

  # End date (exclusive) > max(date_time)
  end_year_df <- get_acoustic_detections(con, end_date = "2016", animal_project_code = "2014_demer")
  expect_gt(as.POSIXct("2016-01-01", tz = "UTC"), max(end_year_df$date_time))
  end_month_df <- get_acoustic_detections(con, end_date = "2015-05", animal_project_code = "2014_demer")
  expect_gt(as.POSIXct("2015-05-01", tz = "UTC"), max(end_month_df$date_time))
  end_day_df <- get_acoustic_detections(con, end_date = "2015-04-25", animal_project_code = "2014_demer")
  expect_gt(as.POSIXct("2015-04-25", tz = "UTC"), max(end_day_df$date_time))

  # Between
  between_year_df <- get_acoustic_detections(con, start_date= "2015", end_date = "2016", animal_project_code = "2014_demer")
  expect_lte(as.POSIXct("2015-01-01", tz = "UTC"), min(between_year_df$date_time))
  expect_gt(as.POSIXct("2016-01-01", tz = "UTC"), max(between_year_df$date_time))
  between_month_df <- get_acoustic_detections(con, start_date = "2015-04", end_date = "2015-05", animal_project_code = "2014_demer")
  expect_lte(as.POSIXct("2015-04-01", tz = "UTC"), min(between_month_df$date_time))
  expect_gt(as.POSIXct("2015-05-01", tz = "UTC"), max(between_month_df$date_time))
  between_day_df <- get_acoustic_detections(con, start_date = "2015-04-24", end_date = "2015-04-25", animal_project_code = "2014_demer")
  expect_lte(as.POSIXct("2015-04-24", tz = "UTC"), min(between_day_df$date_time))
  expect_gt(as.POSIXct("2015-04-25", tz = "UTC"), max(between_day_df$date_time))
})

test_that("get_acoustic_detections() allows selecting on acoustic_tag_id", {
  # Errors
  expect_error(get_acoustic_detections(con, acoustic_tag_id = "not_a_tag_id"))
  expect_error(get_acoustic_detections(con, acoustic_tag_id = c("A69-1601-16130", "not_a_tag_id")))

  # Select single value
  single_select <- "A69-1601-16130" # From 2014_demer
  single_select_df <- get_acoustic_detections(con, acoustic_tag_id = single_select)
  expect_equal(
    single_select_df %>% distinct(acoustic_tag_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("A69-1601-16129", "A69-1601-16130")
  multi_select_df <- get_acoustic_detections(con, acoustic_tag_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(acoustic_tag_id) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_acoustic_detections() allows selecting on animal_project_code", {
  # Errors
  expect_error(get_acoustic_detections(con, animal_project_code = "not_a_project"))
  expect_error(get_acoustic_detections(con, animal_project_code = c("2014_demer", "not_a_project")))

  # Select single value
  single_select <- "2014_demer"
  single_select_df <- get_acoustic_detections(con, animal_project_code = single_select)
  expect_equal(
    single_select_df %>% distinct(animal_project_code) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Selection is case insensitive
  expect_equal(
    get_acoustic_detections(con, animal_project_code = "2014_demer", limit = TRUE),
    get_acoustic_detections(con, animal_project_code = "2014_DEMER", limit = TRUE)
  )

  # Select multiple values
  multi_select <- c("2014_demer", "2015_dijle")
  multi_select_df <- get_acoustic_detections(con, animal_project_code = multi_select)
  expect_equal(
    multi_select_df %>% distinct(animal_project_code) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_acoustic_detections() allows selecting on scientific_name", {
  # Errors
  expect_error(get_acoustic_detections(con, scientific_name = "not_a_sciname"))
  expect_error(get_acoustic_detections(con, scientific_name = "rutilus rutilus")) # Case sensitive
  expect_error(get_acoustic_detections(con, scientific_name = c("Rutilus rutilus", "not_a_sciname")))

  # Select single value
  single_select <- "Rutilus rutilus"
  single_select_df <- get_acoustic_detections(con, scientific_name = single_select)
  expect_equal(
    single_select_df %>% distinct(scientific_name) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("Rutilus rutilus", "Silurus glanis")
  multi_select_df <- get_acoustic_detections(con, scientific_name = multi_select)
  expect_equal(
    multi_select_df %>% distinct(scientific_name) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_acoustic_detections() allows selecting on acoustic_project_code", {
  # Errors
  expect_error(get_acoustic_detections(con, acoustic_project_code = "not_a_project"))
  expect_error(get_acoustic_detections(con, acoustic_project_code = c("demer", "not_a_project")))

  # Select single value
  single_select <- "demer"
  single_select_df <- get_acoustic_detections(con, acoustic_project_code = single_select)
  expect_equal(
    single_select_df %>% distinct(acoustic_project_code) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Selection is case insensitive
  expect_equal(
    get_acoustic_detections(con, acoustic_project_code = "demer", limit = TRUE),
    get_acoustic_detections(con, acoustic_project_code = "DEMER", limit = TRUE)
  )

  # Select multiple values
  multi_select <- c("demer", "dijle")
  multi_select_df <- get_acoustic_detections(con, acoustic_project_code = multi_select)
  expect_equal(
    multi_select_df %>% distinct(acoustic_project_code) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_acoustic_detections() allows selecting on receiver_id", {
  # Errors
  expect_error(get_acoustic_detections(con, receiver_id = "not_a_receiver_id"))
  expect_error(get_acoustic_detections(con, receiver_id = c("VR2W-124070", "not_a_receiver_id")))

  # Select single value
  single_select <- "VR2W-124070" # From demer
  single_select_df <- get_acoustic_detections(con, receiver_id = single_select)
  expect_equal(
    single_select_df %>% distinct(receiver_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("VR2W-124070", "VR2W-124078")
  multi_select_df <- get_acoustic_detections(con, receiver_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(receiver_id) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_acoustic_detections() allows selecting on station_name", {
  # Errors
  expect_error(get_acoustic_detections(con, station_name = "not_a_station_name"))
  expect_error(get_acoustic_detections(con, station_name = c("de-9", "not_a_station_name")))

  # Select single value
  single_select <- "de-9" # From demer
  single_select_df <- get_acoustic_detections(con, station_name = single_select)
  expect_equal(
    single_select_df %>% distinct(station_name) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("de-10", "de-9") # Note that sort() will put de-10 before de-9
  multi_select_df <- get_acoustic_detections(con, station_name = multi_select)
  expect_equal(
    multi_select_df %>% distinct(station_name) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_acoustic_detections() allows to limit to 100 records", {
  # Errors
  expect_error(get_acoustic_detections(con, limit = "not_a_logical"))

  # Limit
  expect_equal(nrow(get_acoustic_detections(con, limit = TRUE)), 100)
  expect_equal(
    nrow(get_acoustic_detections(con, acoustic_project_code = "demer", limit = TRUE)),
    100
  )
})

test_that("get_acoustic_detections() allows selecting on multiple parameters", {
  multiple_parameters_df <- get_acoustic_detections(
    con,
    start_date = "2014-04-24",
    end_date = "2014-04-25",
    acoustic_tag_id = "A69-1601-16130",
    animal_project_code = "2014_demer",
    scientific_name = "Rutilus rutilus",
    acoustic_project_code = "demer",
    receiver_id = "VR2W-124070",
    station_name = "de-9"
  )
  expect_gt(nrow(multiple_parameters_df), 0)
})

test_that("get_acoustic_detections() returns acoustic and acoustic-archival tags", {
  acoustic_df <- get_acoustic_detections(con, acoustic_tag_id = "A69-1601-16130")
  expect_gt(nrow(acoustic_df), 0)

  # A sentinel acoustic-archival tag with pressure + temperature sensor
  acoustic_archival_df <- get_acoustic_detections(con, acoustic_tag_id = c("A69-9006-11100", "A69-9006-11099"))
  expect_gt(nrow(acoustic_archival_df), 0)
  expect_equal(
    acoustic_archival_df %>% distinct(tag_serial_number) %>% pull(),
    "1400185"
  )
})

test_that("get_acoustic_detections() returns detections from acoustic_tag_id_alternative", {
  # The following acoustic_tag_ids only occur as acoustic_tag_id_alternative

  # A69-1105-26 (tag_serial_number = 1734026) is associated with animal
  # - 5902 (2017_Fremur) from 2017-12-01 00:00 to open
  # Almost all its detections are from after the release date
  expect_gt(nrow(get_acoustic_detections(con, acoustic_tag_id = "A69-1105-26")), 0)

  # A69-1105-155 (tag_serial_number = 1712155) is associated with animal
  # - 4140 (OTN-Skjerstadfjorden) from 2017-05-31 01:00 to open
  # All detections are from before the release date, so it should return 0
  expect_equal(nrow(get_acoustic_detections(con, acoustic_tag_id = "A69-1105-155")), 0)
})

test_that("get_acoustic_detections() does not return duplicate detections across acoustic_id and acoustic_id_alternative", {
  # A69-1105-100 is used as acoustic_tag_id once and acoustic_tag_id_alternative twice:
  # tag_serial_number | acoustic_tag_id | acoustic_tag_id_alt | animal | release_date     | animal_project
  # 1634100           | S256-100        | A69-1105-100        | 4282   | 2016-10-19 01:00 | OTN-Skjerstadfjorden
  # 1645100           | S256-100        | A69-1105-100        | 3911   | 2017-03-29 15:30 | OTN-Tosenfjorden
  # 1228004           | A69-1105-100    | S256-100            | 720    | 2015-12-01 00:00 | 2013 Albertkanaal

  # Expect no duplicates
  df <- get_acoustic_detections(con, acoustic_tag_id = "A69-1105-100")
  # expect_equal(nrow(df), nrow(df %>% distinct(detection_id))) # TODO: https://github.com/inbo/etn/issues/216
})

test_that("get_acoustic_detections() does not return duplicate detections when tags are reused", {
  # A69-1601-29925 (tag_serial_number = 1145373) is associated with two animals:
  # - 393 (2012_leopoldkanaal) from 2012-08-21 14:27:00 to 2012-12-10
  # - 394 (2012_leopoldkanaal) from 2012-12-14 13:30:00 to open
  # Detections should be joined with acoustic_tag_id AND datetime, so that they
  # are not duplicated. Note: for df_393 we use a start_date to limit records.
  df_both <- get_acoustic_detections(con, acoustic_tag_id = "A69-1601-29925")
  df_393 <- get_acoustic_detections(con, acoustic_tag_id = "A69-1601-29925", start_date = "2012-12-01", end_date = "2012-12-10")
  df_394 <- get_acoustic_detections(con, acoustic_tag_id = "A69-1601-29925", start_date = "2012-12-14")

  # Expect no duplicates
  expect_equal(nrow(df_both), nrow(df_both %>% distinct(detection_id)))

  # Return correct animal within range
  expect_equal(df_393 %>% distinct(animal_id) %>% pull, 393)
  expect_equal(df_394 %>% distinct(animal_id) %>% pull, 394)
})

test_that("get_acoustic_detections() does not return detections out of date range when tag is associated with animal", {
  # A69-1303-20695 (tag_serial_number = 1097335) is associated with animal
  # 637 (2010_phd_reubens) from 2010-08-09 13:00:00 to 2011-05-19 00:00:00
  in_range_df <- get_acoustic_detections(con, acoustic_tag_id = "A69-1303-20695", start_date = "2010-08-09", end_date = "2011-05-19")
  pre_range_df <- get_acoustic_detections(con, acoustic_tag_id = "A69-1303-20695", end_date = "2010-08-09")
  post_range_df <- get_acoustic_detections(con, acoustic_tag_id = "A69-1303-20695", start_date = "2011-05-19")

  # Expect detections within range
  expect_gt(nrow(in_range_df), 0)

  # Expect no detections outside range
  expect_equal(nrow(pre_range_df), 0)
  expect_equal(nrow(post_range_df), 0)
})

test_that("get_acoustic_detections() can return detections not (yet) associated with an animal", {
  # A180-1702-49684 (tag_serial_number = 1317386) is an "acoustic / animal" tag
  # not yet associated with an animal. It should return detections
  expect_gt(nrow(get_acoustic_detections(con, acoustic_tag_id = "A180-1702-49684")), 0)
})
