test_that("example_dataset() returns error for an invalid dataset name ", {
  expect_error(
    example_dataset(dataset = "invalid_dataset_name"),
    class = "etn_error_example_dataset_not_available"
  )
})

test_that("example_dataset(dataset = '2014_demer') returns a valid frictionless
           data package", {
  expect_no_error(
    frictionless::check_package(example_dataset(dataset = "2014_demer"))
  )
})

test_that("example_dataset(dataset = '2014_demer') returns a data package with
           5 valid resources", {
  `2014_demer` <- example_dataset(dataset = "2014_demer")
  expected_resource_names <- c(
    "animals",
    "tags",
    "detections",
    "deployments",
    "receivers"
  )
  expect_equal(frictionless::resources(`2014_demer`), expected_resource_names)
  expect_no_error(frictionless::read_resource(`2014_demer`, "animals"))
  expect_no_error(frictionless::read_resource(`2014_demer`, "tags"))
  expect_no_error(frictionless::read_resource(`2014_demer`, "detections"))
  expect_no_error(frictionless::read_resource(`2014_demer`, "deployments"))
  expect_no_error(frictionless::read_resource(`2014_demer`, "receivers"))
})
