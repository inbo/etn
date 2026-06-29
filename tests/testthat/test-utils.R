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

# etn_citation() ----------------------------------------------------------

test_that("etn_citation() returns a character vector", {
  expect_type(etn_citation(), "character")
})

test_that("etn_citation() returns the expected package citation", {
  # Rebuild the citation so we have something to check against
  raw_citation <- citation("etn") |>
    format() |>
    # Skip the first row, contains instructions
    purrr::pluck(2L)

  # Clean up the citation so we have something to compare to
  formatted_citation <- stringr::str_sub(
    raw_citation,
    start = 1L,
    # Bibtex instructions start after the link
    end = stringr::str_locate(raw_citation,
                              stringr::fixed("<https://inbo.github.io/etn/>"))[2]
  ) |>
    # Clean up whitespace
    stringr::str_squish() |>
    # Citation ends on a period
    paste0(".")

  expect_identical(
    etn_citation(),
    expected = formatted_citation
  )
})

