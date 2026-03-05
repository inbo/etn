test_that("get_acoustic_citations() prints citations to console", {
  expect_snapshot(
    get_acoustic_citations("Orstedcod")
  )

  expect_snapshot(
    get_acoustic_citations("Pelfish")
  )
})

test_that("get_acoustic_citations() returns a warning when a citation can't be found", {
  # 2011 Bovenschelde Doesn't have a citation

  expect_warning(
    get_acoustic_citations("2011_Bovenschelde")
  )

  expect_snapshot(get_acoustic_citations("2011_Bovenschelde"))

})

test_that("get_acoustic_citations() can return multiple citations for a single acoustic_project_code", {
  expect_identical(
    nrow(get_acoustic_citations("2004_Gudena")),
    2L
  )
})

test_that("get_acoustic_citations() can group citations for multiple acoustic_project_codes", {
  expect_snapshot(
    get_acoustic_citations(
      c("2004_Gudena", "2011_bovenschelde", "2011_Loire", "2011_Warnow",
        "2013_Foyle")
    )
  )
})
