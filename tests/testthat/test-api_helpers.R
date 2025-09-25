
# conduct_parent_to_helpers() ---------------------------------------------


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

# get_etnservice_version() ------------------------------------------------
test_that("get_etnservice_version() returns local etnservice package version", {
  expect_s3_class(
    get_etnservice_version(api = FALSE),
    "package_version"
  )

  expect_identical(
    get_etnservice_version(api = FALSE),
    packageVersion("etnservice")
  )
})

test_that("get_etnservice_version() returns OpenCPU deployed package version", {
  # Cache the HTTP response so we can always test against the same version. I'm
  # testing the ability of get_etnservice_version() to handle the API response,
  # not the API's ability to respond.
  vcr::local_cassette("etnservice_version")

  expect_s3_class(
    get_etnservice_version(api = TRUE),
    "package_version"
  )

  # This is stable because we use a cassette, if the cassette is updated, the
  # expected version needs to be updated as well
  version_in_cassette <- "0.4.3"
  expect_identical(
    get_etnservice_version(api = TRUE),
    package_version(version_in_cassette)
  )
})

test_that("get_etnservice_version() lists available functions of etnservice", {
  # Skip if the OpenCPU server is not reachable
  skip_if_offline(host = "opencpu.lifewatch.be")
  # Skip if the local and deployed versions don't match
  skip_if(!etnservice_version_matches(),
          "Local etnservice and OpenCPU deployed version do not match")

  expect_identical(
    names(get_etnservice_version("all")$fn_checksums),
    ls(getNamespace("etnservice"))
  )
})

test_that("get_etnservice_version() lists checksums of available functions", {
  local_version_info <- get_etnservice_version("all", api = FALSE)
  # test for Single function
  expect_identical(
    local_version_info$fn_checksums$get_acoustic_detections,
    deparse(etnservice::get_acoustic_detections) |> rlang::hash()
  )
})

# etnservice_version_matches() --------------------------------------------

test_that("etnservice_version_matches() can return TRUE/FALSE", {
  expect_type(
    etnservice_version_matches(),
    "logical"
  )
})

test_that("etnservice_version_matches() returns TRUE on mismatch when exact is TRUE", {
  # Mock a etnservice version that is definitely different than local
  mock_version_info <- get_etnservice_version("all", api = FALSE)
  mock_version_info$fn_checksums[4] <- "not_a_real_checksum_value"
  expect_false(
    with_mocked_bindings(
      etnservice_version_matches(exact = TRUE),
      get_etnservice_version = function(...) {
        mock_version_info
      }
    )
  )
})

test_that("etnservice_version_matches() allows a more recent version to be installed when exact is FALSE", {
  expect_true(
    with_mocked_bindings(
      etnservice_version_matches(exact = FALSE),
      # Mock the deployed version to be 0.0.1, the local version is always more
      # recent since I never released a 0.0.1 release.
      get_etnservice_version = function(...) {
        package_version("0.0.1")
      }
    )
  )
})


# extract_temp_key() ------------------------------------------------------


test_that("extract_temp_key() can extract a key from a httr2 response object", {
  vcr::use_cassette("opencpu_cloud_rnorm", {
    response <-
      httr2::request("https://cloud.opencpu.org/ocpu/library/stats/R/rnorm") %>%
      httr2::req_body_json(list(n = 10, mean = 5)) %>%
      httr2::req_perform()
  })
  temp_key <- extract_temp_key(response)
  expect_type(temp_key, "character")
  expect_length(temp_key, 1)
  expect_true(nchar(temp_key) == 15)
})

# get_val() ---------------------------------------------------------------


test_that("get_val() can get a value from a temp_key using rds", {
  # NOTE Dependent on the OpenCPU testing API
  skip_if_offline("cloud.opencpu.org")
  response <-
    httr2::request("https://cloud.opencpu.org/ocpu/library/stats/R/rnorm") %>%
    httr2::req_body_json(list(n = 2)) %>%
    httr2::req_perform()

  temp_key <- extract_temp_key(response)
  domain <- "https://cloud.opencpu.org/ocpu"
  api_out <- get_val(temp_key, domain, format = "rds")
  expect_no_error(api_out)
  expect_type(api_out, "double")
  expect_length(api_out, 2)
})


test_that("get_val() can get a value from a temp_key using feather", {
  # NOTE Dependent on the OpenCPU testing API
  skip_if_offline("cloud.opencpu.org")
  response <-
    httr2::request("https://cloud.opencpu.org/ocpu/library/base/R/expand.grid") %>%
    httr2::req_body_json(
      list(
        animal = c("dogs", "cats"), judgement = c("cute", "amazing", "superb")
      )
    ) %>%
    httr2::req_perform()

  temp_key <- extract_temp_key(response)
  domain <- "https://cloud.opencpu.org/ocpu"
  api_out <- get_val(temp_key, domain, format = "feather")
  expect_no_error(api_out)
  expect_type(api_out, "list")
  expect_s3_class(api_out, "tbl_df")
  expect_length(api_out, 2)
})

# return_parent_arguments() -----------------------------------------------


test_that("return_parent_arguments() can return parent function arguments", {
  # Create some nested functions to test in
  parent_fn <- function(p_arg_1 = "a", p_arg_2 = 4) {
    return_parent_arguments()
  }
  grandparent_fn <- function(gp_arg_1 = pi, gp_arg_2 = c("B", 42)) {
    parent_fn()
  }

  # By default return_parent_arguments() should always return the arguments of
  # the function it was called in.
  expect_identical(
    parent_fn(),
    list(p_arg_1 = "a", p_arg_2 = 4)
  )
  expect_identical(
    grandparent_fn(),
    list(p_arg_1 = "a", p_arg_2 = 4)
  )
})

test_that("return_parent_arguments() can return higher call function arguments", {
  # Create some nested functions to test in
  parent_fn <- function(p_arg_1 = "a", p_arg_2 = 4) {
    return_parent_arguments(depth = 2)
  }
  grandparent_fn <- function(gp_arg_1 = pi, gp_arg_2 = c("B", 42)) {
    parent_fn()
  }

  # By setting depth return_parent_arguments() can also return arguments of
  # higher level calls
  expect_identical(
    grandparent_fn(),
    list(gp_arg_1 = pi, gp_arg_2 = c("B", "42"))
  )
})

# deprecate_warn_connection() ---------------------------------------------


test_that("deprecate_warn_connection() returns warning with function symbol", {
  fn_to_test <- function(connection) {
    deprecate_warn_connection()
  }
  expect_warning(
    fn_to_test(),
    regexp = "The `connection` argument of `fn_to_test\\(\\)` is deprecated as of"
  )
})

# get_parent_fn_name() ----------------------------------------------------


test_that("get_parent_fn_name() can return the name of the parent function", {
  parent_function_with_a_cool_name <- function() {
    get_parent_fn_name()
  }
  expect_identical(
    parent_function_with_a_cool_name(),
    "parent_function_with_a_cool_name"
  )
})

test_that("get_parent_fn_name() can return the name a higher level caller", {
  parent_function_with_a_cool_name <- function() {
    get_parent_fn_name(depth = 2)
  }
  grandparent_function <- function() {
    parent_function_with_a_cool_name()
  }
  expect_identical(
    grandparent_function(),
    "grandparent_function"
  )
})

# validate_login() --------------------------------------------------------


test_that("validate_login() returns TRUE on correct credentials", {
  expect_true(validate_login())
})

test_that("validate_login() returns error on bad credentials", {
  with_mocked_bindings(
    code = {
      expect_error(
        validate_login(),
        regexp = "Failed to login with username: not_a_username. Please check username/password.",
        fixed = TRUE
      )
      # This error should be forwarded to all api functions
      expect_error(
        list_animal_ids(),
        regexp = "Failed to login with username: not_a_username. Please check username/password.",
        fixed = TRUE
      )
    },
    get_credentials = function(...) {
      list(
        username = "not_a_username",
        password = "not the correct pwd"
      )
    },
    # validate_login() is skipped in testing, so we need to pretend we're not.
    is_testing = function(...) {
      FALSE
    },
    # Force using the api by setting the protocol to opencpu
    select_protocol = function(...) {
      "opencpu"
    }
  )
})
