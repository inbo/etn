test_that("No OpenCPU temporary keys are present in the vcr cassettes", {
  # list files in the expected fixture directory, and any other that might be
  # configured.
  fixtures <- list.files(
    c(vcr::vcr_test_path("fixtures"), vcr::vcr_configuration()$dir),
    full.names = TRUE
  ) |>
    # Drop any duplicate filepaths in case the expected path matches the
    # configured one.
    unique()

  key_regex <- "x0[0-9a-f]{13}"

  file_contents <-
    purrr::map(fixtures, \(file) {
      switch(
        tolower(tools::file_ext(file)),
        yaml = ,
        # yml = yaml::read_yaml(file),
        yml = readr::read_lines(file, progress = FALSE),
        qs2 = qs2::qs_read(file),
        cli::cli_abort(
          "Fixture with unexpected filetype found: {tools::file_ext(file)}"
        )
      )
    })

  file_contents |>
    # Drop raw_gzip strings, we don't need to check those for keys.
    purrr::map(function(x) {
      purrr::modify_tree(x, pre = \(node) {
        node[!names(node) %in% "raw_gzip"]
      })
    }) |>
    unlist() |>
    stringr::str_detect(pattern = key_regex) |>
    expect_all_false()
})
