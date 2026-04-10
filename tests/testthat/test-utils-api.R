# get_etnservice_version() ------------------------------------------------
test_that("get_etnservice_version() returns package_version object", {
  testthat::skip_if_offline()
  expect_s3_class(
    get_etnservice_version(),
    "package_version"
  )
})

test_that("get_etnservice_version() lists available functions of etnservice", {
  testthat::skip_if_offline()
  # Skip if there is a mismatch between the locally installed version and the deployed version
  skip_if(utils::packageVersion("etnservice") != get_etnservice_version(),
          "locally installed version of etnservice does not match")

  # Test that all functions in the package are listed
  expect_named(
    get_etnservice_version("all")$fn_checksums,
    ls(getNamespace("etnservice"))
  )
})

# extract_temp_key() ------------------------------------------------------


test_that("extract_temp_key() can extract a key from a httr2 response object", {
  vcr::use_cassette("opencpu_cloud_rnorm", {
    response <-
      httr2::request("https://cloud.opencpu.org/ocpu/library/stats/R/rnorm") |>
      httr2::req_body_json(list(n = 10, mean = 5)) |>
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
  skip_if_http_error("https://cloud.opencpu.org/ocpu/library/stats/R/rnorm")

  response <-
    httr2::request("https://cloud.opencpu.org/ocpu/library/stats/R/rnorm") |>
    httr2::req_body_json(list(n = 2)) |>
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
  skip_if_http_error("https://cloud.opencpu.org/ocpu/library/base/R/expand.grid")
  response <-
    httr2::request("https://cloud.opencpu.org/ocpu/library/base/R/expand.grid") |>
    httr2::req_body_json(
      list(
        animal = c("dogs", "cats"), judgement = c("cute", "amazing", "superb")
      )
    ) |>
    httr2::req_perform()

  temp_key <- extract_temp_key(response)
  domain <- "https://cloud.opencpu.org/ocpu"
  expect_no_error(api_out <- get_val(temp_key, domain, format = "feather"))
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

test_that("deprecate_warn_connection() is triggered on all functions with connection arg", {
  # List all functions with a conneciton argument
  etn_namespace <- asNamespace("etn")
  fns_with_connection_arg <-
    getNamespaceExports(etn_namespace) |>
    purrr::keep(\(fn) {
      "connection" %in% names(
        formals(get(fn, envir = etn_namespace))
      )
    })

  # Check that there are still functions with a `connection` argument
  expect_true(length(fns_with_connection_arg) > 0)

  # For every of these functions, run them with an invalid connection. But
  # don't fail on any other errors. To fail early, I'm sabotaging the decision
  # tree to select what protocol path to follow. As this happens early in a
  # downstream helper, the connection warning should fire first. This greatly
  # speeds up the test.
  for (fn in fns_with_connection_arg) {
    expect_warning(tryCatch(
      expr = {
        with_mocked_bindings(
          code = {
            do.call(fn,
              args = list(connection = "not a connection object")
            )
          },
          # Sabotage conduct_parent_to_helpers() so we fail early.
          select_protocol = function(...) {
            rlang::abort(class = "etn_no_protocol")
          }
        )
      },
      # Suppress all errors downstream
      error = function(e) {
        NULL
      }
    ), class = "lifecycle_warning_deprecated",
    label = sprintf("`%s()` to warn for connection deprecation",
                    fn))
  }
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
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  expect_true(validate_login())
})

test_that("validate_login() returns error on bad credentials", {
  testthat::skip_if_offline()
  with_mocked_bindings(
    code = {
      expect_error(
        validate_login(),
        regexp = "Failed to log in with username: not_a_username. Please check credentials.",
        fixed = TRUE
      )
      # This error should be forwarded to all api functions
      expect_error(
        list_animal_ids(),
        regexp = "Failed to log in with username: not_a_username. Please check credentials.",
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
