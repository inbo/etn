library("vcr") # *Required* as vcr is set up on loading
invisible(vcr::vcr_configure(
  filter_sensitive_data = list("<<<my_userid>>>" = Sys.getenv('ETN_USER'),
                               "<<<my_pwd>>>" = Sys.getenv('ETN_PWD')),
  dir = vcr::vcr_test_path("fixtures")
))
