con <- connect_to_etn()

test_that("get_cpod_deployments() returns error for incorrect connection", {
  expect_error(
    get_cpod_deployments(con = "not_a_connection"),
    "Not a connection object to database."
  )
})

test_that("get_cpod_deployments() returns a tibble", {
  df <- get_cpod_deployments(con)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_cpod_deployments() returns unique deployment_id", {
  df <- get_cpod_deployments(con)
  expect_equal(nrow(df), nrow(df %>% distinct(deployment_id)))
})

test_that("get_cpod_deployments() returns the expected columns", {
  df <- get_cpod_deployments(con)
  expected_col_names <- c(
    "deployment_id",
    "receiver_id",
    "cpod_project_code",
    "station_name",
    "deploy_date_time",
    "deploy_latitude",
    "deploy_longitude",
    "mooring_type",
    "battery_estimated_end_date",
    "activation_date_time",
    "recover_date_time",
    "download_date_time",
    "valid_data_until_date_time",
    "acoustic_release_number",
    "hydrophone_cable_length",
    "hydrophone_sensitivity",
    "amplifier_sensitivity",
    "sample_rate",
    "recording_name",
    "comments"
  )
  expect_equal(names(df), expected_col_names)
})

test_that("get_cpod_deployments() allows selecting on deployment_id", {
  # Errors
  expect_error(get_cpod_deployments(con, deployment_id = "not_a_deployment_id"))
  expect_error(get_cpod_deployments(con, deployment_id = c("2584", "not_a_deployment_id")))

  # Select single value
  single_select <- 2584 # From cpod-lifewatch
  single_select_df <- get_cpod_deployments(con, deployment_id = single_select)
  expect_equal(
    single_select_df %>% distinct(deployment_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("2584", 2595) # Characters are allowed
  multi_select_df <- get_cpod_deployments(con, deployment_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(deployment_id) %>% pull() %>% sort(),
    c(as.integer(multi_select)) # Output will be all integer
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_cpod_deployments() allows selecting on receiver_id", {
  # Errors
  expect_error(get_cpod_deployments(con, receiver_id = "not_a_receiver_id"))
  expect_error(get_cpod_deployments(con, receiver_id = c("POD-2723", "not_a_receiver_id")))

  # Select single value
  single_select <- "POD-2723" # From cpod-lifewatch
  single_select_df <- get_cpod_deployments(con, receiver_id = single_select)
  expect_equal(
    single_select_df %>% distinct(receiver_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("POD-2723", "POD-2724")
  multi_select_df <- get_cpod_deployments(con, receiver_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(receiver_id) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_cpod_deployments() allows selecting on cpod_project_code", {
  # Errors
  expect_error(get_cpod_deployments(con, cpod_project_code = "not_a_project"))
  expect_error(get_cpod_deployments(con, cpod_project_code = c("cpod-lifewatch", "not_a_project")))

  # Select single value
  single_select <- "cpod-lifewatch"
  single_select_df <- get_cpod_deployments(con, cpod_project_code = single_select)
  expect_equal(
    single_select_df %>% distinct(cpod_project_code) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Selection is case insensitive
  expect_equal(
    get_cpod_deployments(con, cpod_project_code = "cpod-lifewatch"),
    get_cpod_deployments(con, cpod_project_code = "CPOD-LIFEWATCH")
  )

  # Select multiple values
  multi_select <- c("cpod-lifewatch", "cpod-od-natuur")
  multi_select_df <- get_cpod_deployments(con, cpod_project_code = multi_select)
  expect_equal(
    multi_select_df %>% distinct(cpod_project_code) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_cpod_deployments() allows selecting on station_name", {
  # Errors
  expect_error(get_cpod_deployments(con, station_name = "not_a_station_name"))
  expect_error(get_cpod_deployments(con, station_name = c("bpns-Oostendebank Oost", "not_a_station_name")))

  # Select single value
  single_select <- "bpns-Oostendebank Oost" # From cpod-lifewatch and cpod-od-natuur
  single_select_df <- get_cpod_deployments(con, station_name = single_select)
  expect_equal(
    single_select_df %>% distinct(station_name) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("bpns-Oostendebank Oost", "bpns-oostdyck west") # Will be sorted like this
  multi_select_df <- get_cpod_deployments(con, station_name = multi_select)
  expect_equal(
    multi_select_df %>% distinct(station_name) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_cpod_deployments() allows selecting on open deployments only", {
  # Errors
  expect_error(get_cpod_deployments(con, open_only = "not_a_logical"))

  # ws1 is an open ended acoustic project
  all_df <- get_cpod_deployments(con, cpod_project_code = "cpod-lifewatch", open_only = FALSE)

  # Default returns all
  default_df <- get_cpod_deployments(con, cpod_project_code = "cpod-lifewatch")
  expect_equal(default_df, all_df)

  # Open only returns deployments with no end date
  open_only_df <- get_cpod_deployments(con, cpod_project_code = "cpod-lifewatch", open_only = TRUE)
  expect_lt(nrow(open_only_df), nrow(all_df))
  expect_true(all(is.na(open_only_df$recover_date_time)))
})

test_that("get_cpod_deployments() allows selecting on multiple parameters", {
  multiple_parameters_df <- get_cpod_deployments(
    con,
    deployment_id = 2584,
    receiver_id = "POD-2723",
    cpod_project_code = "cpod-lifewatch",
    station_name = "bpns-Oostendebank Oost",
    open_only = FALSE
  )
  expect_gt(nrow(multiple_parameters_df), 0)
})

test_that("get_cpod_deployments() does not return acoustic deployments", {
  # VR2W-124070 is an acoustic receiver
  df <- get_cpod_deployments(con, receiver_id = "VR2W-124070")
  expect_equal(nrow(df), 0)
})
