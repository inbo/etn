context("test_get_receivers")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_input_get_receivers", {
  expect_error(get_receivers(con, network_project = "Bad_network_project"))
})
