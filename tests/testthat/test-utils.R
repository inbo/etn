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
    new = c(ETN_PROTOCOL = "public"),
    expect_equal(select_protocol(), "public")
  )
})

test_that("select_protocol() returns error on disallowed values", {
  withr::with_envvar(
    new = c(ETN_PROTOCOL = "not a protocol"),
            expect_error(select_protocol(),
                         regexp = 'not "not a protocol"')
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
