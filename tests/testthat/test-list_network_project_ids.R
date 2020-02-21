con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_list_network_project_ids", {
  expect_is(list_network_project_ids(con), "character")
  expect_false(any(duplicated(list_network_project_ids(con))))
  expect_true("thornton" %in% list_network_project_ids(con))
  expect_false("phd_reubens" %in% list_network_project_ids(con))
})
