test_that("add_resource() returns a valid Data Package", {
  package <- example_dataset()
  animals_file <-
    system.file("extdata", "2014_demer", "animals.csv", package = "etn")
  animals <- readr::read_csv(animals_file, show_col_types = FALSE)
  package <- frictionless::remove_resource(package, "animals")

  expect_no_error(
    frictionless::check_package(
      add_resource(package, "animals", animals)
    )
  )
})

test_that("add_resource() returns error on invalid Data Package", {
  package <- example_dataset()
  animals_file <-
    system.file("extdata", "2014_demer", "animals.csv", package = "etn")
  animals <- readr::read_csv(animals_file, show_col_types = FALSE)

  expect_error(
    add_resource(list(), "animals", animals),
    class = "frictionless_error_package_invalid"
  )
})

test_that("add_resource() returns error on invalid resource name", {
  package <- example_dataset()
  animals_file <-
    system.file("extdata", "2014_demer", "animals.csv", package = "etn")
  animals <- readr::read_csv(animals_file, show_col_types = FALSE)

  expect_error(
    add_resource(package, "not_a_resource_name", animals),
    class = "etn_error_resource_name_invalid"
  )
  expect_error(
    add_resource(package, "ANIMALS", animals),
    class = "etn_error_resource_name_invalid"
  )
})
