con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("Test output", {
  expect_is(list_network_project_codes(con), "character")
  expect_false(any(duplicated(list_network_project_codes(con))))
  expect_true("thornton" %in% list_network_project_codes(con))
  expect_false("phd_reubens" %in% list_network_project_codes(con))
})
