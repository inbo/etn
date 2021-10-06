con <- connect_to_etn()

test_that("list_animal_project_codes() returns unique list of values", {
  expect_is(list_animal_project_codes(con), "character")
  expect_false(any(duplicated(list_animal_project_codes(con))))
  expect_true("2014_demer" %in% list_animal_project_codes(con))

  # Should not include network projects
  expect_false("demer" %in% list_animal_project_codes(con))
})
