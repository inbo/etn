con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_network_projects", {
  expect_is(network_projects(con), "character")
  expect_false(any(duplicated(network_projects(con))))
  expect_true("thornton" %in% network_projects(con))
  expect_false("phd_reubens" %in% network_projects(con))
})
