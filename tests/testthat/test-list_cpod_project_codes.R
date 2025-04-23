test_that("list_cpod_project_codes() returns unique list of values using api", {
  vcr::use_cassette("list_cpod_project_codes", {
    vector <- list_cpod_project_codes()
  })

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))
  expect_true("cpod-lifewatch" %in% vector)
  # Should not include animal or network projects
  expect_false("2014_demer" %in% vector)
  expect_false("demer" %in% vector)
})

test_that("list_cpod_project_codes() returns unique list of values using local db", {
  skip_if_not_localdb()

  vector_sql <- list_cpod_project_codes(api = FALSE)
  expect_type(vector_sql, "character")
  expect_false(any(duplicated(vector_sql)))
  expect_true(all(!is.na(vector_sql)))
  expect_true("cpod-lifewatch" %in% vector_sql)
  # Should not include animal or network projects
  expect_false("2014_demer" %in% vector_sql)
  expect_false("demer" %in% vector_sql)
})
