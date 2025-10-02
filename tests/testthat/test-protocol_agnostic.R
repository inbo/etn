# This file contains tests that verify that certain listing functions in the ETN
# package return identical results regardless of whether they are using the API
# or a local database connection.

# Test if listing functions are protocol agnostic -------------------------

test_that("list_animal_project_codes() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_animal_project_codes())
})

test_that("list_acoustic_project_codes() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_acoustic_project_codes())
})

test_that("list_animal_projects() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_animal_projects())
})

test_that("list_acoustic_projects() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_acoustic_projects())
})

test_that("list_animal_ids() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_animal_ids())
})
