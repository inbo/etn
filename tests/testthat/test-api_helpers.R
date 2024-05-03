
# conduct_parent_to_helpers() ---------------------------------------------


test_that("conduct_parent_to_helpers() can stop on bad input parameters", {
  expect_error(
    conduct_parent_to_helpers(api = "not a flag!")
  )
})

# extract_temp_key() ------------------------------------------------------


test_that("extract_temp_key() can extract a key from a httr::response object", {
  vcr::use_cassette("opencpu_cloud_rnorm", {
    response <-
      httr::POST("https://cloud.opencpu.org/ocpu/library/stats/R/rnorm",
                 body = list(n = 2))
  })
  temp_key <- extract_temp_key(response)
  expect_type(temp_key, "character")
  expect_length(temp_key, 1)
  expect_true(nchar(temp_key) == 15)
})

# get_val() ---------------------------------------------------------------


test_that("get_val() can get a value from a temp_key", {
  # NOTE Dependent on the OpenCPU testing API
  response <-
    httr::POST("https://cloud.opencpu.org/ocpu/library/stats/R/rnorm",
      body = list(n = 2)
    )
  temp_key <- extract_temp_key(response)
  domain <- "https://cloud.opencpu.org/ocpu"

  expect_no_error(api_out <- get_val(temp_key, domain))
  expect_type(api_out, "double")
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

vcr::use_cassette("httpbin_error_status", {
  test_that("check_opencpu_response() returns error on HTTP error codes", {
    expect_error(check_opencpu_response(
      httr::RETRY(
        verb = "GET",
        "http://httpbin.org/status/404",
        terminate_on = 404
      )
    ),
    regexp = "API request failed: Client error: (404) Not Found",
    fixed = TRUE)
    expect_error(check_opencpu_response(
      httr::RETRY(
        verb = "GET",
        "http://httpbin.org/status/504",
        terminate_on = 504
      )
    ),
    regexp = "API request failed: Server error: (504) Gateway Timeout",
    fixed = TRUE)
    expect_error(check_opencpu_response(
      httr::RETRY(
        verb = "GET",
        "http://httpbin.org/status/429",
        terminate_on = 429
      )
    ),
    regexp = "API request failed: Client error: (429) Too Many Requests (RFC 6585)",
    fixed = TRUE)
  })
})

test_that("deprecate_warn_connection() returns warning with function symbol", {
  fn_to_test <- function(connection) {deprecate_warn_connection()}
  expect_warning(
    fn_to_test(),
    regexp = "The `connection` argument of `fn_to_test\\(\\)` is deprecated as of"
  )
})

test_that("get_parent_fn_name() can return the name of the parent function", {
  parent_function_with_a_cool_name <- function(){get_parent_fn_name()}
  expect_identical(
    parent_function_with_a_cool_name(),
    "parent_function_with_a_cool_name"
  )
})

test_that("get_parent_fn_name() can return the name a higher level caller", {
  parent_function_with_a_cool_name <- function(){get_parent_fn_name(depth = 2)}
  grandparent_function <- function(){parent_function_with_a_cool_name()}
  expect_identical(
    grandparent_function(),
    "grandparent_function"
  )
})
