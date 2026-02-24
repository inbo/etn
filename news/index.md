# Changelog

## etn 3.0.0

### Use etn on your computer 🎉

- etn now connects to the ETN database with an API provided by the
  [etnservice](https://github.com/inbo/etnservice) package
  ([\#280](https://github.com/inbo/etn/issues/280)). This means you can
  use the package from your own computer. Note that this will be slower
  than running it from the [VLIZ RStudio
  server](https://rstudio4.vliz.be/).
- etn will automatically switch to a local database connection when
  available (e.g. the VLIZ RStudio server). Use
  `Sys.setenv(ETN_PROTOCOL = "opencpu")` to override this behaviour and
  force the package to use the API
  ([\#398](https://github.com/inbo/etn/issues/398)).
- Queries via the API and the VLIZ RStudio Server will return the same
  results ([\#317](https://github.com/inbo/etn/issues/317)).
- When using a local database connection, etn will check if the
  installed helper package etnservice that is used to place these
  queries is up to date with the one deployed via the API. This is to
  ensure that queries placed via the API and via the local database
  connection always result in consistent results. If the installed
  version of etnservice is older, you will be prompted to install a
  newer version ([\#385](https://github.com/inbo/etn/issues/385)).

### Credentials

**Breaking change! Action required**

Your credentials (username and password) to connect to the ETN database
are no longer passed via the `connection` argument. They are asked or
retrieved from your `.Renviron` file every time you run a function.

- New authentication mechanism
  ([\#317](https://github.com/inbo/etn/issues/317),
  [\#339](https://github.com/inbo/etn/issues/339),
  [\#338](https://github.com/inbo/etn/issues/338),
  [\#228](https://github.com/inbo/etn/issues/228)).
- New vignette
  [`vignette("authentication")`](https://inbo.github.io/etn/articles/authentication.md).
- `connection` argument is deprecated in all functions
  ([\#301](https://github.com/inbo/etn/issues/301)).
- [`connect_to_etn()`](https://inbo.github.io/etn/reference/connect_to_etn.md)
  is deprecated ([\#303](https://github.com/inbo/etn/issues/303)).

Here is how you can migrate:

1.  Use the new RStudio server (<https://rstudio4.vliz.be/>). The
    LifeWatch RStudio server (<https://rstudio.lifewatch.be>) won’t work
    with this version of etn and will be discontinued.

2.  Follow the steps in
    [`vignette("authentication")`](https://inbo.github.io/etn/articles/authentication.md)
    to look up and store your credentials.

3.  Update your scripts:

    ``` r
    # Good
    get_animals(animal_id = 305)

    # Bad
    connect_to_etn()
    get_animals(con, animal_id = 305)
    get_animals(connection = con, animal_id = 305)
    ```

### Accessing data

- [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md)
  now uses a different protocol to retrieve data. It can now reliably
  return 10M+ detections without timeouts
  ([\#384](https://github.com/inbo/etn/issues/384),
  [\#382](https://github.com/inbo/etn/issues/382),
  [\#323](https://github.com/inbo/etn/issues/323)).
- [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md)
  now returns a progress bar for large queries
  ([\#384](https://github.com/inbo/etn/issues/384)).
- [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md)
  now has a `deployment_id` filter argument
  ([\#382](https://github.com/inbo/etn/issues/382),
  [\#340](https://github.com/inbo/etn/issues/340)).
- [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md)
  now has a `tag_serial_number` argument, which is more reliable than
  `acoustic_tag_id` (which is still supported). Thanks
  [@lottepohl](https://github.com/lottepohl) for the suggestion
  ([\#408](https://github.com/inbo/etn/issues/408),
  [\#386](https://github.com/inbo/etn/issues/386)).
- [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md)
  may return fewer (erroneous) detections than before, due to fixes in
  the database.
- [`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md)
  now includes `type_type = "archival"` data
  ([\#365](https://github.com/inbo/etn/issues/365)).

### Changes for developers

- New vignette
  [`vignette("options")`](https://inbo.github.io/etn/articles/options.md)
  describes some developer options
  ([\#398](https://github.com/inbo/etn/issues/398)).
- Contributors can change the default domain of the API to the URL of a
  test server via the environmental variable `ETN_TEST_API`
  ([\#383](https://github.com/inbo/etn/issues/383)).
- Tests make use of [vcr](https://docs.ropensci.org/vcr) to record and
  replay HTTP requests to the API. These results are stored in
  `/tests/fixtures` ([\#432](https://github.com/inbo/etn/issues/432)).
- Tests have new helper functions, including `skip_if_not_localdb()`,
  `skip_if_http_error()` and `expect_protocol_agnostic()`. The latter is
  used to compare SQL vs API calls in `test-protocol_agnostic.R`
  ([\#436](https://github.com/inbo/etn/issues/436)).
- Tests for `download_acoustic_datasets()` are updated for archival tags
  and SQL vs API calls and makes use of markdown snapshots
  ([\#366](https://github.com/inbo/etn/issues/366)).
- pkgdown website is now automatically build by a GitHub Action and is
  served from the `gh-pages` branch. The `docs/` directory has been
  removed ([\#456](https://github.com/inbo/etn/issues/456)).
- [`vignette("acoustic-telemetry")`](https://inbo.github.io/etn/articles/acoustic-telemetry.md)
  is precompiled with `vignettes/precompile.R`, so it doesn’t run for
  every build ([\#473](https://github.com/inbo/etn/issues/473)).

### Miscellaneous

- etn now relies on R \>= 4.1.0 (because of
  [arrow](https://github.com/apache/arrow/) and
  [vcr](https://docs.ropensci.org/vcr) dependencies) and uses base pipes
  (`|>` rather than `%>%`)
  ([\#327](https://github.com/inbo/etn/issues/327),
  [\#384](https://github.com/inbo/etn/issues/384)).
- [`write_dwc()`](https://inbo.github.io/etn/reference/write_dwc.md) now
  invisibly returns the transformed data as a list of data frames
  (rather than a data frame)
  ([\#302](https://github.com/inbo/etn/issues/302)).
- Previously deprecated functions `get_deployments()`,
  `get_detections()`, `get_projects()`, `get_receivers()`,
  `list_network_project_codes()` are now removed.
- `vignette("etn_fields")` was outdated and has been removed
  ([\#468](https://github.com/inbo/etn/issues/468)).

## etn 2.2.2

### Bug fixes

- `check_value()` now correctly formats `NA` values returned by `list_`
  functions ([\#356](https://github.com/inbo/etn/issues/356),
  [\#357](https://github.com/inbo/etn/issues/357)).
- [`list_receiver_ids()`](https://inbo.github.io/etn/reference/list_receiver_ids.md)
  no longer return duplicate values
  ([\#357](https://github.com/inbo/etn/issues/357)).
- [`write_dwc()`](https://inbo.github.io/etn/reference/write_dwc.md) now
  handles empty `rights_holder`
  ([\#356](https://github.com/inbo/etn/issues/356)).

### Miscellaneous

- Tests depending on local database connection are now skipped when it
  is absent on testing machine
  ([\#346](https://github.com/inbo/etn/issues/346)).
- Funder is updated and custom authors are removed
  ([\#311](https://github.com/inbo/etn/issues/311)).
- The README now has a Zenodo badge
  ([\#352](https://github.com/inbo/etn/issues/352),
  [\#355](https://github.com/inbo/etn/issues/355)).
- New `CITATION.cff` file
  ([\#337](https://github.com/inbo/etn/issues/337)).
- pkgdown website has been updated
  ([\#354](https://github.com/inbo/etn/issues/354)).

## etn 2.2.1

- [`write_dwc()`](https://inbo.github.io/etn/reference/write_dwc.md) now
  supports uppercase `animal_project_code`s
  ([\#289](https://github.com/inbo/etn/issues/289)).
- [`write_dwc()`](https://inbo.github.io/etn/reference/write_dwc.md) no
  longer breaks on updated dependency
  ([\#293](https://github.com/inbo/etn/issues/293)).

## etn 2.2.0

- `NEWS.md` file is added to communicate changes to the package.
- `depth_in_meters` field is added to
  [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md)
  ([\#261](https://github.com/inbo/etn/issues/261)).
- [`download_acoustic_dataset()`](https://inbo.github.io/etn/reference/download_acoustic_dataset.md)
  no longer breaks on missing fields in `datapackage.json`.
- Unit tests are stricter
  ([\#268](https://github.com/inbo/etn/issues/268)).

## etn 2.1.0

- Funder and default README.Rmd are added
  ([\#247](https://github.com/inbo/etn/issues/247)).
- New function
  [`write_dwc()`](https://inbo.github.io/etn/reference/write_dwc.md)
  transforms acoustic telemetry data to Darwin Core that can be
  harvested by OBIS and GBIF
  ([\#257](https://github.com/inbo/etn/issues/257)).

## etn 2.0.0

This releases updates the package to make use of the new model and scope
of ETN. Have a look at [this
milestone](https://github.com/inbo/etn/milestone/2) for all issues that
are included.

- `tag_serial_number` is now the primary identifier for tags. Tags can
  have multiple types, subtypes and sensors. Acoustic information is
  related to the `acoustic_tag_id`.
- `acoustic` scope remains completely covered, but is now reflected in
  function names. This allows us to implement additional scopes
  (e.g. `cpod`) in the future.
- Old function names are deprecated.
- New
  [`vignette("acoustic-telemetry")`](https://inbo.github.io/etn/articles/acoustic-telemetry.md)
  showcases an acoustic use case.
- Test coverage is increased.
