library("vcr") # *Required* as vcr is set up on loading
invisible(vcr::vcr_configure(
  filter_sensitive_data = list("<<<my_userid>>>" = Sys.getenv('userid'),
                               "<<<my_pwd>>>" = Sys.getenv('pwd')),
  dir = vcr::vcr_test_path("fixtures")
))

rlang::check_installed("qs2", "To use qs2 serializer for vcr")
