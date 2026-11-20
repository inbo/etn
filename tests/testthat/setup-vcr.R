# Configure VCR -----------------------------------------------------------

# Set up vcr to filter out sensitive data and store cassettes in the correct
# folder. If we are using the test deployment of OpenCPU, turn off vcr.
invisible(vcr::vcr_configure(
  filter_sensitive_data = list(
    "<<<my_userid>>>" = Sys.getenv("ETN_USER"),
    "<<<my_pwd>>>" = Sys.getenv("ETN_PWD")
  ),
  dir = vcr::vcr_test_path("fixtures")
))

# if we are using a test deployment of OpenCPU, turn off vcr. All requests on
# the test deployment are performed on the live (test) API.
if (using_test_deployment()) {
  vcr::turn_off(ignore_cassettes = TRUE)
}

# Teardown ----------------------------------------------------------------

withr::defer(
  anonymise_cassettes(list.files(vcr::vcr_test_path("fixtures"), full.names = TRUE)),
  envir = testthat::teardown_env()
)
