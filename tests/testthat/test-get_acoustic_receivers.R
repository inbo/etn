# con <- connect_to_etn()
#
# test_that("get_acoustic_receivers() returns error for incorrect connection", {
#   expect_error(
#     get_acoustic_receivers(con = "not_a_connection"),
#     "Not a connection object to database."
#   )
# })

test_that("get_acoustic_receivers() returns a tibble", {
  df <- get_acoustic_receivers()
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
  df_sql <- get_acoustic_receivers(api = FALSE)
  expect_s3_class(df_sql, "data.frame")
  expect_s3_class(df_sql, "tbl")
})

# TODO: re-enable after https://github.com/inbo/etn/issues/251
# test_that("get_acoustic_receivers() returns unique receiver_id", {
#   df <- get_acoustic_receivers(con)
#   expect_equal(nrow(df), nrow(df %>% distinct(receiver_id)))
# })

test_that("get_acoustic_receivers() returns the expected columns", {
  df <- get_acoustic_receivers()
  expected_col_names <- c(
    "receiver_id",
    "manufacturer",
    "receiver_model",
    "receiver_serial_number",
    "modem_address",
    "status",
    "battery_estimated_life",
    "owner_organization",
    "financing_project",
    "built_in_acoustic_tag_id",
    "ar_model",
    "ar_serial_number",
    "ar_battery_estimated_life",
    "ar_voltage_at_deploy",
    "ar_interrogate_code",
    "ar_receive_frequency",
    "ar_reply_frequency",
    "ar_ping_rate",
    "ar_enable_code_address",
    "ar_release_code",
    "ar_disable_code",
    "ar_tilt_code",
    "ar_tilt_after_deploy"
  )
  expect_equal(names(df), expected_col_names)
})

test_that("get_acoustic_receivers() allows selecting on receiver_id", {
  # Errors
  expect_error(
    get_acoustic_receivers(receiver_id = "not_a_receiver_id"),
    regexp = "Can't find receiver_id `not_a_receiver_id` in"
    )
  expect_error(
    get_acoustic_receivers(receiver_id = c("VR2W-124070", "not_a_receiver_id")),
    regexp = "Can't find receiver_id `VR2W-124070` and/or `not_a_receiver_id` in"
    )

  # Select single value
  single_select <- "VR2W-124070" # From demer
  single_select_df <- get_acoustic_receivers(receiver_id = single_select)
  expect_equal(
    single_select_df %>% distinct(receiver_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("VR2W-124070", "VR2W-124078")
  multi_select_df <- get_acoustic_receivers(receiver_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(receiver_id) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})



test_that("get_acoustic_receivers() allows selecting on status", {
  # Errors
  expect_error(
    get_acoustic_receivers(status = "not_a_status"),
    regexp = "Can't find status `not_a_status` in"
    )
  expect_error(
    get_acoustic_receivers(status = c("broken", "not_a_status")),
    regexp = "Can't find status `broken` and/or `not_a_status` in"
    )

  # Select single value
  single_select <- "broken"
  single_select_df <- get_acoustic_receivers(status = single_select)
  expect_equal(
    single_select_df %>% distinct(status) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("broken", "lost")
  multi_select_df <- get_acoustic_receivers(status = multi_select)
  expect_equal(
    multi_select_df %>% distinct(status) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_acoustic_receivers() does not return cpod receivers", {
  # POD-3330 is a cpod receiver
  df <- get_acoustic_receivers(receiver_id = "POD-3330")
  expect_equal(nrow(df), 0)
})
