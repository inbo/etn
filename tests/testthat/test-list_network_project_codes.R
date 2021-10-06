con <- connect_to_etn()

test_that("list_network_project_codes() returns unique list of values", {
  expect_is(list_network_project_codes(con), "character")
  expect_false(any(duplicated(list_network_project_codes(con))))
  expect_true("demer" %in% list_network_project_codes(con))

  # Don't expect animal projects
  expect_false("2014_demer" %in% list_network_project_codes(con))
})
