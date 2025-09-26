test_that("conduct_parent_to_helpers() can stop on bad input parameters", {
  expect_error(
    conduct_parent_to_helpers(protocol = "not a protocol!")
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
      conduct_parent_to_helpers(protocol = "localdb"),
      # Mock a function call
      get_parent_fn_name = function(...) {
        "list_animal_project_codes"
      },
      # Mock a mismatch between the installed and deployed version of etnservice
      etnservice_version_matches = function(...) {
        FALSE
      },
      # Mock the deployed version of etnservice to a very high version
      get_etnservice_version = function(...) {
        "9999.0.0"
      }
    ),
    class = "rlib_error_package_not_found"
  )
})
