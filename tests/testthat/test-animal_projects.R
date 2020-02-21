con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_animal_projects", {
  expect_is(animal_projects(con), "character")
  expect_false(any(duplicated(animal_projects(con))))
  expect_true("phd_reubens" %in% animal_projects(con))
  expect_false("thornton" %in% animal_projects(con))
})
