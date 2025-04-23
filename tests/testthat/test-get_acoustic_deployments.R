# Cached response from the API
vcr::use_cassette("get_acoustic_deployments", {
  df <- get_acoustic_deployments(api = TRUE)
})

test_that("[API] get_acoustic_deployments() returns a tibble", {
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("[SQL] get_acoustic_deployments() returns a tibble", {
  skip_if_not_localdb()

  # Response via local database connection
  df_sql <- get_acoustic_deployments(api = FALSE)

  expect_s3_class(df_sql, "data.frame")
  expect_s3_class(df_sql, "tbl")
})

test_that("[API] get_acoustic_deployments() returns unique deployment_id", {
  expect_equal(nrow(df), nrow(df %>% distinct(deployment_id)))
})

test_that("[SQL] get_acoustic_deployments() returns unique deployment_id", {
  skip_if_not_localdb()

  # Response via local database connection
  df_sql <- get_acoustic_deployments(api = FALSE)

  expect_equal(nrow(df_sql), nrow(df_sql %>% distinct(deployment_id)))
})

test_that("[API] get_acoustic_deployments() returns the expected columns", {
  expected_col_names <- c(
    "deployment_id",
    "receiver_id",
    "acoustic_project_code",
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
    "comments"
  )
  expect_identical(names(df), expected_col_names)
})

test_that("[SQL] get_acoustic_deployments() returns the expected columns", {
  expected_col_names <- c(
    "deployment_id",
    "receiver_id",
    "acoustic_project_code",
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
    "comments"
  )
  skip_if_not_localdb()

  # Response via local database connection
  df_sql <- get_acoustic_deployments(api = FALSE)

  expect_equal(names(df_sql), expected_col_names)
})

test_that("[API] get_acoustic_deployments() allows selecting on deployment_id", {
  # Errors
  expect_error(
    get_acoustic_deployments(deployment_id = "not_a_deployment_id"),
    regexp = "Can't find receiver_id `not_a_deployment_id` in"
    )
  expect_error(
    get_acoustic_deployments(deployment_id = c("1437", "not_a_deployment_id")),
    regexp = "Can't find receiver_id `1437` and/or `not_a_deployment_id` in:"
    )

  # Select single value
  single_select <- 1437 # From demer
  vcr::use_cassette("acoustic_deployments_single_deployment_id", {
    single_select_df <- get_acoustic_deployments(deployment_id = single_select)
  })

  expect_equal(
    single_select_df %>% distinct(deployment_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("1437", 1588) # Characters are allowed
  vcr::use_cassette("acoustic_deployments_multi_deployment_id", {
    multi_select_df <- get_acoustic_deployments(deployment_id = multi_select)
  })
  expect_equal(
    multi_select_df %>% distinct(deployment_id) %>% pull() %>% sort(),
    c(as.integer(multi_select)) # Output will be all integer
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("[SQL] get_acoustic_deployments() allows selecting on deployment_id", {
  skip_if_not_localdb()

  # Errors
  expect_error(
    get_acoustic_deployments(deployment_id = "not_a_deployment_id",
                             api = FALSE),
    regexp = "Can't find receiver_id `not_a_deployment_id` in"
  )
  expect_error(
    get_acoustic_deployments(deployment_id = c("1437", "not_a_deployment_id"),
                             api = FALSE),
    regexp = "Can't find receiver_id `1437` and/or `not_a_deployment_id` in:"
  )

  # Select single value
  single_select <- 1437 # From demer
  single_select_df <- get_acoustic_deployments(deployment_id = single_select,
                                               api = FALSE)
  expect_equal(
    single_select_df %>% distinct(deployment_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("1437", 1588) # Characters are allowed
  multi_select_df <- get_acoustic_deployments(deployment_id = multi_select,
                                              api = FALSE)
  expect_equal(
    multi_select_df %>% distinct(deployment_id) %>% pull() %>% sort(),
    c(as.integer(multi_select)) # Output will be all integer
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("[API] get_acoustic_deployments() allows selecting on receiver_id", {
  # Errors
  expect_error(
    get_acoustic_deployments(receiver_id = "not_a_receiver_id"),
    regexp = "Can't find receiver_id `not_a_receiver_id` in"
    )
  expect_error(
    get_acoustic_deployments(receiver_id = c("VR2W-124070", "not_a_receiver_id")),
    regexp = "Can't find receiver_id `VR2W-124070` and/or `not_a_receiver_id` in"
    )

  # Select single value
  single_select <- "VR2W-124070" # From demer
  single_select_df <- get_acoustic_deployments(receiver_id = single_select)
  expect_equal(
    single_select_df %>% distinct(receiver_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("VR2W-124070", "VR2W-124078")
  multi_select_df <- get_acoustic_deployments(receiver_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(receiver_id) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("[SQL] get_acoustic_deployments() allows selecting on receiver_id", {
  skip_if_not_localdb()

  # Errors
  expect_error(
    get_acoustic_deployments(receiver_id = "not_a_receiver_id",
                             api = FALSE),
    regexp = "Can't find receiver_id `not_a_receiver_id` in"
  )
  expect_error(
    get_acoustic_deployments(receiver_id = c("VR2W-124070", "not_a_receiver_id"),
                             api = FALSE),
    regexp = "Can't find receiver_id `VR2W-124070` and/or `not_a_receiver_id` in"
  )

  # Select single value
  single_select <- "VR2W-124070" # From demer
  single_select_df <- get_acoustic_deployments(receiver_id = single_select,
                                               api = FALSE)
  expect_equal(
    single_select_df %>% distinct(receiver_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("VR2W-124070", "VR2W-124078")
  multi_select_df <- get_acoustic_deployments(receiver_id = multi_select,
                                              api = FALSE)
  expect_equal(
    multi_select_df %>% distinct(receiver_id) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("[API] get_acoustic_deployments() allows selecting on acoustic_project_code", {
  # Errors
  expect_error(
    get_acoustic_deployments(acoustic_project_code = "not_a_project"),
    regexp = "Can't find acoustic_project_code `not_a_project` in"
    )
  expect_error(
    get_acoustic_deployments(acoustic_project_code = c("demer", "not_a_project")),
    regexp = "Can't find acoustic_project_code `demer` and/or `not_a_project` in"
    )

  # Select single value
  single_select <- "demer"
  single_select_df <- get_acoustic_deployments(acoustic_project_code = single_select)
  expect_equal(
    single_select_df %>% distinct(acoustic_project_code) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Selection is case insensitive
  expect_equal(
    get_acoustic_deployments(acoustic_project_code = "demer"),
    get_acoustic_deployments(acoustic_project_code = "DEMER")
  )

  # Select multiple values
  multi_select <- c("demer", "dijle")
  multi_select_df <- get_acoustic_deployments(acoustic_project_code = multi_select)
  expect_equal(
    multi_select_df %>% distinct(acoustic_project_code) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("[SQL] get_acoustic_deployments() allows selecting on acoustic_project_code", {
  skip_if_not_localdb()

  # Errors
  expect_error(
    get_acoustic_deployments(acoustic_project_code = "not_a_project",
                             api = FALSE),
    regexp = "Can't find acoustic_project_code `not_a_project` in"
  )
  expect_error(
    get_acoustic_deployments(acoustic_project_code = c("demer", "not_a_project"),
                             api = FALSE),
    regexp = "Can't find acoustic_project_code `demer` and/or `not_a_project` in"
  )

  # Select single value
  single_select <- "demer"
  single_select_df <- get_acoustic_deployments(acoustic_project_code = single_select,
                                               api = FALSE)
  expect_equal(
    single_select_df %>% distinct(acoustic_project_code) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Selection is case insensitive
  expect_equal(
    get_acoustic_deployments(acoustic_project_code = "demer",
                             api = FALSE),
    get_acoustic_deployments(acoustic_project_code = "DEMER",
                             api = FALSE)
  )

  # Select multiple values
  multi_select <- c("demer", "dijle")
  multi_select_df <- get_acoustic_deployments(acoustic_project_code = multi_select,
                                              api = FALSE)
  expect_equal(
    multi_select_df %>% distinct(acoustic_project_code) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("[API] get_acoustic_deployments() allows selecting on station_name", {
  # Errors
  expect_error(
    get_acoustic_deployments(station_name = "not_a_station_name"),
    regexp = "Can't find station_name `not_a_station_name` in"
    )
  expect_error(
    get_acoustic_deployments(station_name = c("de-9", "not_a_station_name")),
    regexp = "Can't find station_name `de-9` and/or `not_a_station_name` in"
    )

  # Select single value
  single_select <- "de-9" # From demer
  single_select_df <- get_acoustic_deployments(station_name = single_select)
  expect_equal(
    single_select_df %>% distinct(station_name) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("de-10", "de-9") # Note that sort() will put de-10 before de-9
  multi_select_df <- get_acoustic_deployments(station_name = multi_select)
  expect_equal(
    multi_select_df %>% distinct(station_name) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("[SQL] get_acoustic_deployments() allows selecting on station_name", {
  skip_if_not_localdb()

  # Errors
  expect_error(
    get_acoustic_deployments(station_name = "not_a_station_name",
                             api = FALSE),
    regexp = "Can't find station_name `not_a_station_name` in"
  )
  expect_error(
    get_acoustic_deployments(station_name = c("de-9", "not_a_station_name"),
                             api = FALSE),
    regexp = "Can't find station_name `de-9` and/or `not_a_station_name` in"
  )

  # Select single value
  single_select <- "de-9" # From demer
  single_select_df <- get_acoustic_deployments(station_name = single_select,
                                               api = FALSE)
  expect_equal(
    single_select_df %>% distinct(station_name) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("de-10", "de-9") # Note that sort() will put de-10 before de-9
  multi_select_df <- get_acoustic_deployments(station_name = multi_select,
                                              api = FALSE)
  expect_equal(
    multi_select_df %>% distinct(station_name) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("[API] get_acoustic_deployments() allows selecting on open deployments only", {
  # Errors
  expect_error(
    get_acoustic_deployments(open_only = "not_a_logical"),
    regexp = "argument is not interpretable as logical"
    )

  # ws1 is an open ended acoustic project
  all_df <-
    get_acoustic_deployments(acoustic_project_code = "ws1", open_only = FALSE)

  # Default returns all
  default_df <- get_acoustic_deployments(acoustic_project_code = "ws1")
  expect_equal(default_df, all_df)

  # Open only returns deployments with no end date
  open_only_df <- get_acoustic_deployments(acoustic_project_code = "ws1", open_only = TRUE)
  expect_lt(nrow(open_only_df), nrow(all_df))
  expect_true(all(is.na(open_only_df$recover_date_time)))
})

test_that("[SQL] get_acoustic_deployments() allows selecting on open deployments only", {

  skip_if_not_localdb()

  # Errors
  expect_error(
    get_acoustic_deployments(open_only = "not_a_logical",
                             api = FALSE),
    regexp = "argument is not interpretable as logical"
  )

  # ws1 is an open ended acoustic project
  all_df <-
    get_acoustic_deployments(acoustic_project_code = "ws1",
                             open_only = FALSE,
                             api = FALSE)

  # Default returns all
  default_df <- get_acoustic_deployments(acoustic_project_code = "ws1",
                                         api = FALSE)
  expect_equal(default_df, all_df)

  # Open only returns deployments with no end date
  open_only_df <- get_acoustic_deployments(acoustic_project_code = "ws1",
                                           open_only = TRUE,
                                           api = FALSE)
  expect_lt(nrow(open_only_df), nrow(all_df))
  expect_true(all(is.na(open_only_df$recover_date_time)))
})

test_that("[API] get_acoustic_deployments() allows selecting on multiple parameters", {
  multiple_parameters_df <- get_acoustic_deployments(
    receiver_id = "VR2W-124070",
    acoustic_project_code = "demer",
    station_name = "de-9",
    open_only = FALSE
  )
  expect_gt(nrow(multiple_parameters_df), 0)
})

test_that("[SQL] get_acoustic_deployments() allows selecting on multiple parameters", {
  skip_if_not_localdb()

  multiple_parameters_df <- get_acoustic_deployments(
    receiver_id = "VR2W-124070",
    acoustic_project_code = "demer",
    station_name = "de-9",
    open_only = FALSE,
    api = FALSE
  )
  expect_gt(nrow(multiple_parameters_df), 0)
})

test_that("[API] get_acoustic_deployments() does not return cpod deployments", {
  # POD-3610 is a cpod receiver
  df <- get_acoustic_deployments(receiver_id = "POD-3610")
  expect_equal(nrow(df), 0)
})

test_that("[SQL] get_acoustic_deployments() does not return cpod deployments", {
  skip_if_not_localdb()

  # POD-3610 is a cpod receiver
  df <- get_acoustic_deployments(receiver_id = "POD-3610", api = FALSE)
  expect_equal(nrow(df), 0)
})
