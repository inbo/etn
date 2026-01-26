# deprecate_warn_connection() ---------------------------------------------
test_that("deprecate_warn_connection() returns warning when connection is provided", {
  # because this helper looks at the environment two levels up, it's not very
  # practical to test it directly. So here we test it by calling a function that
  # uses it.
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
})


# select_protocol() -------------------------------------------------------

test_that("select_protocol() returns 'localdb' when nodename ends on vliz.be", {
  with_mocked_bindings(
    expect_equal(select_protocol(), "localdb"),
    # Mock running on the RStudio server
    get_nodename = function(...) "rstudio4.web.vliz.be"
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
