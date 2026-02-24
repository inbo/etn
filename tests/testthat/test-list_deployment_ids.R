test_that("list_deployment_ids() returns unique list of values using api", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  vcr::use_cassette("list_deployment_ids", {
    deployment_ids <-
      with_mocked_bindings(list_deployment_ids(), select_protocol = \(x) "opencpu")
  })

  expect_type(deployment_ids, "integer")
  expect_false(any(duplicated(deployment_ids)))
  expect_true(all(!is.na(deployment_ids)))

  expect_true(1437 %in% deployment_ids)
})

test_that("list_deployment_ids() returns unique list of values using local db", {
  skip_if_no_authentication()
  skip_if_not_localdb()
  deployment_ids_sql <-
    with_mocked_bindings(list_deployment_ids(), select_protocol = \(x) "localdb")

  expect_type(deployment_ids_sql, "integer")
  expect_false(any(duplicated(deployment_ids_sql)))
  expect_true(all(!is.na(deployment_ids_sql)))

  expect_true(1437 %in% deployment_ids_sql)
})
