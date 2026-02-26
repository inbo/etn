test_that("conduct_parent_to_helpers() can stop on bad input parameters", {
  expect_error(
    conduct_parent_to_helpers(protocol = "not a protocol!")
  )
})

test_that("conduct_parent_to_helper() does not forward ignored arguments", {
  skip_if_no_authentication()
  vcr::local_cassette("conduct_acoustic_projects")
  # If the `acoustic_project_code` arguments is not forwarded, then the result
  # should be the same as passing without arguments.
  expect_identical(
    with_mocked_bindings(
      conduct_parent_to_helpers(ignored_arguments = "acoustic_project_code"),
      return_parent_arguments = \(...) list(acoustic_project_code = "2013_Foyle"),
      get_parent_fn_name = \(...) "get_acoustic_projects",
      select_protocol = \(...) "opencpu"
    ),
    with_mocked_bindings(
      conduct_parent_to_helpers(),
      return_parent_arguments = \(...) list(),
      get_parent_fn_name = \(...) "get_acoustic_projects",
      select_protocol = \(...) "opencpu"
    )
  )
})

test_that("conduct_parent_to_helpers() asks for etnservice update if needed", {
  withr::local_options(
    # Disable the prompt, and have rlang return an error to test on.
    list(rlib_restart_package_not_found = FALSE)
  )

  expect_error(
    with_mocked_bindings(
      # We only check the versions for calls to the local database
      # Suppress the inform message.
      suppressMessages(conduct_parent_to_helpers(protocol = "localdb")),
      # Mock a function call
      get_parent_fn_name = function(...) {
        "list_animal_project_codes"
      },
      # Mock the deployed version of etnservice to a very high version
      get_etnservice_version = function(...) {
        "9999.0.0"
      }
    ),
    class = "rlib_error_package_not_found"
  )
})
