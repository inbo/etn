test_that("example_dataset() returns error for an invalid dataset name ", {
  expect_error(
    example_dataset(dataset = "invalid_dataset_name"),
    class = "etn_error_example_dataset_not_available"
  )
})

test_that("example_dataset(dataset = '2014_DEMER') returns a valid frictionless
           data package", {
  expect_no_error(
    frictionless::check_package(example_dataset(dataset = "2014_DEMER"))
  )
})

test_that("example_dataset(dataset = '2014_DEMER') returns a data package with
           5 valid resources", {
  `2014_DEMER` <- example_dataset(dataset = "2014_DEMER")
  expected_resource_names <- c(
    "animals",
    "tags",
    "detections",
    "deployments",
    "receivers"
  )
  expect_equal(frictionless::resources(`2014_DEMER`), expected_resource_names)
  expect_no_error(frictionless::read_resource(`2014_DEMER`, "animals"))
  expect_no_error(frictionless::read_resource(`2014_DEMER`, "tags"))
  expect_no_error(frictionless::read_resource(`2014_DEMER`, "detections"))
  expect_no_error(frictionless::read_resource(`2014_DEMER`, "deployments"))
  expect_no_error(frictionless::read_resource(`2014_DEMER`, "receivers"))
})

test_that("example_dataset(dataset = '2014_DEMER') returns a data package with
           the expected metadata", {
  `2014_DEMER` <- example_dataset(dataset = "2014_DEMER")
  expect_equal(`2014_DEMER`$id, "https://doi.org/10.14284/432")
  expect_true(is.null(`2014_DEMER`$profile))
})
