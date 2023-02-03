con <- connect_to_etn()

test_that("get_deployments() redirects to correct function", {
  expect_warning(get_deployments(con), "is deprecated")
  suppressWarnings(expect_identical(
    get_deployments(con, network_project_code = "demer"),
    get_acoustic_deployments(con, acoustic_project_code = "demer")
  ))
})

test_that("get_detections() redirects to correct function", {
  expect_warning(get_detections(con, limit = TRUE), "is deprecated")
  suppressWarnings(expect_identical(
    get_detections(
      con,
      tag_id = "A69-1601-16130",
      network_project_code = "demer",
      limit = TRUE
    ),
    get_acoustic_detections(
      con,
      acoustic_tag_id = "A69-1601-16130",
      acoustic_project_code = "demer",
      limit = TRUE
    )
  ))
})

test_that("get_projects() redirects to correct function", {
  expect_warning(get_projects(con), "is deprecated")
  suppressWarnings(expect_identical(
    get_projects(con), get_animal_projects(con)
  ))
  suppressWarnings(expect_identical(
    get_projects(con, project_type = "animal"), get_animal_projects(con)
  ))
  suppressWarnings(expect_identical(
    get_projects(con, project_type = "network"), get_acoustic_projects(con)
  ))
  suppressWarnings(expect_identical(
    get_projects(con, application_type = "cpod"), get_cpod_projects(con)
  ))
})

test_that("get_receivers() redirects to correct function", {
  expect_warning(get_receivers(con), "is deprecated")
  suppressWarnings(expect_identical(
    get_receivers(con), get_acoustic_receivers(con)
  ))
})

test_that("list_network_project_codes() redirects to correct function", {
  expect_warning(list_network_project_codes(con), "is deprecated")
  suppressWarnings(expect_identical(
    list_network_project_codes(con), list_acoustic_project_codes(con)
  ))
})

test_that("list_tag_ids() redirects to correct function", {
  expect_warning(list_tag_ids(con), "is deprecated")
  suppressWarnings(expect_identical(
    list_tag_ids(con), list_acoustic_tag_ids(con)
  ))
})
