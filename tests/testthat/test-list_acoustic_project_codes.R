con <- connect_to_etn()

test_that("list_acoustic_project_codes() returns unique list of values", {
  vector <- list_acoustic_project_codes(con)

  expect_is(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("demer" %in% vector)
  # Should not include animal or cpod projects
  expect_false("2014_demer" %in% vector)
  expect_false("cpod-lifewatch" %in% vector)
})
