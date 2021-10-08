con <- connect_to_etn()

test_that("list_cpod_project_codes() returns unique list of values", {
  expect_is(list_cpod_project_codes(con), "character")
  expect_false(any(duplicated(list_cpod_project_codes(con))))
  expect_true("cpod-lifewatch" %in% list_cpod_project_codes(con))

  # Should not include animal or network projects
  expect_false("2014_demer" %in% list_cpod_project_codes(con))
  expect_false("demer" %in% list_cpod_project_codes(con))
})
