test_that("forward_to_api() can forward call to api using JSON retrieval", {
  skip_if_offline("opencpu.lifewatch.be")
  skip_if_no_authentication()

  expect_type(
    forward_to_api("list_animal_ids", payload = list(), json = TRUE),
    "integer"
  )
})

test_that("forward_to_api() can forward call to api using two step retrieval", {
  skip_if_offline("opencpu.lifewatch.be")
  skip_if_no_authentication()

  expect_type(
    forward_to_api("list_animal_ids", payload = list(), json = FALSE),
    "integer"
  )
})

test_that("forward_to_api() can send requests to domains other than etn", {
  skip_if_offline("cloud.opencpu.org")
  skip_if_http_error("https://cloud.opencpu.org/ocpu/library/stats/R/")
  # Direct request via JSON)
  expect_type(
    forward_to_api(
      "rnorm",
      payload = list(n = 2, mean = 4),
      add_credentials = FALSE,
      json = TRUE,
      domain = "https://cloud.opencpu.org/ocpu/library/stats/R/"
    ),
    "double"
  )
  # Two requests (via POST then GET)
  expect_type(
    forward_to_api(
      "rnorm",
      payload = list(n = 2, mean = 3),
      add_credentials = FALSE,
      json = FALSE,
      domain = "https://cloud.opencpu.org/ocpu/library/stats/R/"
    ),
    "double"
  )
})

test_that("forward_to_api() can send requests to test domain", {
  skip_if(Sys.getenv("ETN_TEST_API", unset = "True") == "True",
    message = "ETN_TEST_API is not set to test deployment url."
  )

  expect_type(
    forward_to_api(
      function_identity = "list_scientific_names",
      payload = list(),
      add_credentials = TRUE,
      json = TRUE
    ),
    "character"
  )
})

test_that("forward_to_api() can forward R errors to client console", {
  skip_if_offline("cloud.opencpu.org")
  skip_if_http_error("https://cloud.opencpu.org/ocpu/library/stats/R/")

  expect_error(
    forward_to_api("rnorm",
      payload = list(mean = 4), # results in error: "n" is missing,
      json = FALSE,
      domain = "https://cloud.opencpu.org/ocpu/library/stats/R/",
      add_credentials = FALSE
    ),
    regexp = 'argument "n" is missing, with no default',
    fixed = FALSE # don't check for caller
  )
})

test_that("opencpu should not pass backtrace", {
  skip_if_offline("opencpu.lifewatch.be")

  # Errors from the API should be forwarded, but backtrace should not be.
  error_message <- expect_error(
    forward_to_api("get_animals",
                   payload = list(animal_id = "not_an_animal_id"),
                  )
  )
  expect_no_match(error_message$message, "Backtrace")
})

