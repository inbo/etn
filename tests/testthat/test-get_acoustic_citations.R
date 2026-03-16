test_that("get_acoustic_citations() prints citations to console", {
  skip_if_offline("marineinfo.org")

  expect_snapshot(
    get_acoustic_citations("Orstedcod")
  )

  expect_message(
    get_acoustic_citations("Orstedcod"),
    regexp = "Winter, Erwin. (2021). ORSTED COD project",
    fixed = TRUE
  )
})

test_that("get_acoustic_citations() removes HTML tags from printed citation", {
  loire_message <- expect_message(get_acoustic_citations("2011_Loire"),
                                  "2011_Loire",
                                  fixed = FALSE
  )

  # Loire returns a <i> italic tag in the title, get_acoustic_citations() should
  # remove this
  expect_no_match(
    as.character(loire_message),
                 regexp = "<i>"
  )

})

test_that("get_acoustic_citations() returns a warning when a citation can't be found", {
  skip_if_offline("marineinfo.org")

  # 2011 Bovenschelde Doesn't have a citation
  expect_warning(
    get_acoustic_citations("2011_Bovenschelde"),
    class = "etn_no_citation_found"
  )
})

test_that("get_acoustic_citations() can handle multiple project codes", {
  skip_if_offline("marineinfo.org")

  expect_snapshot(
    get_acoustic_citations(
      c("2011_Loire", "2011_Warnow", "2013_Foyle")
    )
  )

  # Even if some don't have citations
  one_citation_missing <-
    get_acoustic_citations(
      c("Pelfish", "2011_bovenschelde")
    )

  expect_length(one_citation_missing, 1L)

  expect_snapshot(
    get_acoustic_citations(
      c("Pelfish", "2011_bovenschelde")
    )
  )

  # A warning should still be returned for the missing citation
  expect_warning(
    get_acoustic_citations(
      c("Pelfish", "2011_bovenschelde")
    ),
    class = "etn_no_citation_found"
  )

})

test_that("get_acoustic_citations() invisibly returns a list", {
  skip_if_offline("marineinfo.org")

  expect_invisible(
    get_acoustic_citations("2004_Gudena")
  )

  expect_type(
    get_acoustic_citations("2004_Gudena"),
    "list"
  )

  # The list names should correspond with the acoustic project names
  expect_named(get_acoustic_citations("2004_Gudena"),
               "2004_Gudena")

  # acoustic project code that exposed a bug in missing response element
  # `datasetrec` earlier
  expect_type(
    get_acoustic_citations("Mrc_vliz"),
    "list"
  )
})

test_that("get_acoustic_citations() can return multiple citations for a single acoustic_project_code", {
  skip_if_offline("marineinfo.org")

  expect_length(
    get_acoustic_citations("2004_Gudena"),
    2L
  )
})

test_that("get_acoustic_citations() can group citations for multiple acoustic_project_codes", {
  skip_if_offline("marineinfo.org")

  expect_snapshot(
    get_acoustic_citations(
      c("2004_Gudena", "2011_bovenschelde", "2011_Loire", "2011_Warnow",
        "2013_Foyle")
    )
  )
})

test_that("get_acoustic_citations() returns DOIs when available", {
  skip_if_offline("marineinfo.org")
})

test_that("get_acoustic_citations() shouldn't include DOI when unknown", {
  skip_if_offline("marineinfo.org")

  # Pelfish doesn't supply a DOI
  pelfish_message <- expect_message(
    get_acoustic_citations("Pelfish"),
    regexp = NULL # capture message
  )

  # Check for the presense of a DOI url ending on NA
  expect_false(
    stringr::str_detect(pelfish_message$message,
                        stringr::fixed("https://doi.org/NA"))
  )

  # Check for the presence of a DOI
  expect_false(
    stringr::str_detect(pelfish_message$message,
                        stringr::fixed("doi"))
  )
})
