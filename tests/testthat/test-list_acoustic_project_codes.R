con <- connect_to_etn()

test_that("list_acoustic_project_codes() returns unique list of values", {
  expect_is(list_acoustic_project_codes(con), "character")
  expect_false(any(duplicated(list_acoustic_project_codes(con))))
  expect_true("demer" %in% list_acoustic_project_codes(con))

  # Should not include animal or cpod projects
  expect_false("2014_demer" %in% list_acoustic_project_codes(con))
  expect_false("cpod-lifewatch" %in% list_acoustic_project_codes(con))
})
