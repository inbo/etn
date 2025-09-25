library("vcr") # *Required* as vcr is set up on loading

# Helpers for VCR ---------------------------------------------------------

#' Check if tests are running on the OpenCPU test deployment
#'
#' If the tests are running on the OpenCPU test deployment, the production
#' cassettes will not work. And all tests need to run on the live test API.
#'
#' @return Logical, `TRUE` if the tests are running on the test deployment,
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

# Configure VCR -----------------------------------------------------------

# Set up vcr to filter out sensitive data and store cassettes in the correct
# folder. If we are using the test deployment of OpenCPU, turn off vcr.
invisible(vcr::vcr_configure(
  filter_sensitive_data = list("<<<my_userid>>>" = Sys.getenv("ETN_USER"),
                               "<<<my_pwd>>>" = Sys.getenv("ETN_PWD")),
  dir = vcr::vcr_test_path("fixtures")
))

# if we are using a test deployment of OpenCPU, turn off vcr. All requests on
# the test deployment are performed on the live (test) API.
if(using_test_deployment()){
  vcr::turn_off(ignore_cassettes = TRUE)
}

