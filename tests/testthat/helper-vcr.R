library("vcr") # *Required* as vcr is set up on loading

# Helpers for VCR ---------------------------------------------------------

#' Check if tests are running on the OpenCPU test deployment
#'
#' If the tests are running on the OpenCPU test deployment, the production
#' cassettes will not work. And all tests need to run on the live test API.
#'
#' @returns Logical, `TRUE` if the tests are running on the test deployment,
#' `FALSE` if the tests are running on the production deployment.
#' @family helper functions
#' @noRd
#' @examples
#' withr::local_envvar(ETN_TEST_API =
#'     "https://some.secret.url/opencpu/etnservice/R")
#' using_test_deployment()
#' withr::local_envvar(ETN_TEST_API = NA) # unset
#' using_test_deployment()
using_test_deployment <- function() {
  # Check if the ETN_TEST_API environment variable is set to anything, if not,
  # then we are using the production deployment
  Sys.getenv("ETN_TEST_API", unset = "URL_UNSET") != "URL_UNSET"
}

anonymise_cassettes <- function(paths) {
  if (!all(file.exists(paths))) {
    cli::cli_abort("{paths[!file.exists(paths]} can not be found.")
  }
  purrr::walk(paths, function(path) {
    ext <- tolower(tools::file_ext(path))
    cassette <- switch(
      ext,
      qs2 = qs2::qs_read(path),
      yaml = ,
      yml = readr::read_lines(path, progress = FALSE),
      cli::cli_abort("Unsupported file type {tools::file_ext(path)}.")
    )
    key_regex <- "x0[0-9a-f]{13}"
    key_lut <- integer()
    # Replace key with sequential key: unique within every cassette.
    anon_cassette <-
      purrr::modify_tree(
        cassette,
        leaf = \(leaf) {
          if (!is.character(leaf)) {
            return(leaf)
          }

          stringr::str_replace_all(
            leaf,
            pattern = key_regex,
            replacement = \(matches) {
              new_keys <- setdiff(matches, names(key_lut))
              if (length(new_keys) > 0L) {
                key_lut[new_keys] <<- length(key_lut) + seq_along(new_keys)
              }
              # Add a non hexidecimal character to the anonymised key, so they
              # don't match the valid key regex.
              sprintf("x0Q%012d", key_lut[matches])
            }
          )
        }
      )
    switch(
      ext,
      qs2 = qs2::qs_save(anon_cassette, path),
      yaml = ,
      yml = yaml::write_yaml(anon_cassette, path)
    )
  })
}

