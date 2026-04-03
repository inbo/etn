# deprecate_warn_connection() ---------------------------------------------
test_that("deprecate_warn_connection() returns warning when connection is provided", {
  # because this helper looks at the environment two levels up, it's not very
  # practical to test it directly. So here we test it by calling a function that
  # uses it.
  skip_if_offline("opencpu.lifewatch.be")
  skip_if_no_authentication()

  expect_warning(
    list_animal_project_codes(connection = "any object should cause a warning"),
    class = "lifecycle_warning_deprecated"
  )
})


# localdb_is_available() --------------------------------------------------

test_that("localdb_is_available() returns TRUE when nodename ends on vliz.be", {
  with_mocked_bindings(
    expect_true(localdb_is_available()),
    # Mock running on the RStudio server
    get_nodename = function(...) "rstudio4.web.vliz.be"
  )

  with_mocked_bindings(
    expect_true(localdb_is_available()),
    # Mock running from new RStudio server
    get_nodename = function(...) "rstudio.europeantrackingnetwork.org"
  )
})


# select_protocol() -------------------------------------------------------

test_that("select_protocol() returns 'localdb' when nodename ends on vliz.be", {
  with_mocked_bindings(
    expect_equal(select_protocol(), "localdb"),
    # Mock running on the RStudio server
    get_nodename = function(...) "rstudio4.web.vliz.be"
  )

  with_mocked_bindings(
    expect_equal(select_protocol(), "localdb"),
    # Mock running from new RStudio server
    get_nodename = function(...) "rstudio.europeantrackingnetwork.org"
  )
})

test_that("select_protocol() returns 'opencpu' when nodename does not end on vliz.be", {
  with_mocked_bindings(
    expect_equal(select_protocol(), "opencpu"),
    # Mock running NOT on the RStudio server
    get_nodename = function(...) "my-computer"
  )
})

test_that("select_protocol() allows user override by environmental variable", {
  withr::with_envvar(
    new = c(ETN_PROTOCOL = "myprotocol"),
    expect_equal(select_protocol(), "myprotocol")
  )
})

# credentials_are_set() ---------------------------------------------------

test_that("credentials_are_set() returns TRUE when both credentials are set", {
  withr::with_envvar(
    new = c(ETN_USER = "user", ETN_PWD = "password"),
    expect_true(credentials_are_set())
  )
})

test_that("credentials_are_set() returns FALSE when ETN_USER is not set", {
  withr::with_envvar(new = c(ETN_USER = NA, ETN_PWD = "password"),
                     expect_false(credentials_are_set()))
})

test_that("credentials_are_set() returns FALSE when ETN_PWD is not set", {
  withr::with_envvar(
    new = c(ETN_USER = "user", ETN_PWD = NA),
    expect_false(credentials_are_set())
  )
})


# convert_units() ---------------------------------------------------------

test_that("convert_units() correctly adds unit info to cols with unit suffix", {
  df_with_units <- tibble::tibble(
    depth_m = c(1, 4, -4),
    height_m = c(44, 89, 44)
  ) |>
    convert_units()

  # Check for unit class
  expect_identical(
    purrr::map(df_with_units, class),
    list(
      depth_m = "units",
      height_m = "units"
    )
  )

  # Check for unit value
  expect_identical(
    purrr::map(df_with_units, units),
    list(
      depth_m = structure(list(
        numerator = "m", denominator = character(0)
      ), class = "symbolic_units"),
      height_m = structure(list(
        numerator = "m", denominator = character(0)
      ), class = "symbolic_units")
    )
  )
})

test_that("convert_units() leaves columns without a unit unscaved", {
  df_no_units <- tibble::tibble("receiver_id" = c(11, 22, 33))

  expect_identical(
    convert_units(df_no_units),
    df_no_units
  )

  df_mixed <- tibble::tibble(
    depth_m = c(1, 4, -4),
    receiver_id = c(11, 22, 33)
  )

  expect_identical(
    purrr::map(convert_units(df_mixed), class),
    list(
      depth_m = "units",
      receiver_id = "integer"
    )
  )
})

test_that("convert_units() doesn't error on columns without a _", {
  df_no_underscore <- tibble::tibble(
    depth = c(1, 4, -4),
    height = c(44, 89, 44)
  )

  expect_identical(
    convert_units(df_no_underscore),
    df_no_underscore
  )
})

## NOTE : It might actually be better to correct this client side, and have
## `get_receiver_logs() convert known cases of  this to the correct `_°C`
## instead
test_that("convert_units() can handle _C as a synonm for _°C", {
  df_celsius <- tibble::tibble(
    temp_C = c(1, 4, -4)
  ) |>
    convert_units()

  expect_identical(
    purrr::map(df_celsius, units),
    list(
      temp_C = structure(list(
        numerator = "°C", denominator = character(0)
      ), class = "symbolic_units")
    )
  )
})
