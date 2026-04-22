# etn (development version)

* Add European Union as funder (for [STRAITS](https://doi.org/10.3030/101094649)) (#497).
* `get_acoustic_projects()`, `get_animal_projects()` and `get_cpod_projects()` now have an optional argument `citation`, which adds the columns `citation`, `doi`, `contact_name`, `contact_email` and `contact_affiliation` to the data frame. This makes it easier to cite projects or contact the responsible. The citation information is obtained via [MarineInfo](https://marineinfo.org) (#518).
* New `example_dataset()` reads an example dataset (`"2014_DEMER"`) as a data package (#530).
* New `get_package()` gets all data related to an animal project as a [Data Package](https://specs.frictionlessdata.io/data-package/). Use this in combination with `write_package()` to download a dataset (#544).
* `read_package()` and `write_package()` are reexported from `{frictionless}` to read and write data packages (#525).
* `download_acoustic_dataset()` is deprecated. Please use `get_package()` and then `write_package()` instead (#559).
* `write_dwc()` now uses a data package as input, rather than reading from the ETN database (#528). This means the function can be used locally. In addition:
  * [institutionCode](http://rs.tdwg.org/dwc/terms/institutionCode) is always set to `"VLIZ"` as maintainer of ETN. The `institution_code` parameter has been removed.
  * [license](http://purl.org/dc/terms/license) is set to `"CC-BY-4.0"` or `"CC0-1.0"` rather than a URL. The input for the `license` parameter has been updated accordingly.
  * [identificationVerificationStatus](http://rs.tdwg.org/dwc/terms/identificationVerificationStatus) has been added and is set to `"verified by expert"` for all records, since the taxon is assumed to be well-known before the tag was attached.
* The [function reference](https://inbo.github.io/etn/reference/index.html) has been reorganized (#549)

# etn 3.0.0

## Use etn on your computer 🎉

* etn now connects to the ETN database with an API provided by the [etnservice](https://github.com/inbo/etnservice) package (#280). This means you can use the package from your own computer. Note that this will be slower than running it from the [ETN RStudio server](https://rstudio.europeantrackingnetwork.org).
* etn will automatically switch to a local database connection when available (e.g. the ETN RStudio server). Use `Sys.setenv(ETN_PROTOCOL = "opencpu")` to override this behaviour and force the package to use the API (#398).
* Queries via the API and the ETN RStudio Server will return the same results (#317).
* When using a local database connection, etn will check if the installed helper package etnservice that is used to place these queries is up to date with the one deployed via the API. This is to ensure that queries placed via the API and via the local database connection always result in consistent results. If the installed version of etnservice is older, you will be prompted to install a newer version (#385).

## Credentials

::: {.callout-important}
**Breaking change! Action required**
:::

Your credentials (username and password) to connect to the ETN database are no longer passed via the `connection` argument. They are asked or retrieved from your `.Renviron` file every time you run a function.

* New authentication mechanism (#317, #339, #338, #228).
* New vignette `vignette("authentication")`.
* `connection` argument is deprecated in all functions (#301).
* `connect_to_etn()` is deprecated (#303).

Here is how you can migrate:

1. Use the new ETN RStudio server (<https://rstudio.europeantrackingnetwork.org>). The LifeWatch RStudio server (<https://rstudio.lifewatch.be>) won't work with this version of etn and will be discontinued.
2. Follow the steps in `vignette("authentication")` to look up and store your credentials.
3. Update your scripts:

   ```r
   # Good
   get_animals(animal_id = 305)

   # Bad
   connect_to_etn()
   get_animals(con, animal_id = 305)
   get_animals(connection = con, animal_id = 305)
   ```

## Accessing data

* `get_acoustic_detections()` now uses a different protocol to retrieve data. It can now reliably return 10M+ detections without timeouts (#384, #382, #323).
* `get_acoustic_detections()` now returns a progress bar for large queries (#384).
* `get_acoustic_detections()` now has a `deployment_id` filter argument (#382, #340).
* `get_acoustic_detections()` now has a `tag_serial_number` argument, which is more reliable than `acoustic_tag_id` (which is still supported). Thanks @lottepohl for the suggestion (#408, #386).
* `get_acoustic_detections()` may return fewer (erroneous) detections than before, due to fixes in the database.
* `get_animals()` now includes `type_type = "archival"` data (#365).

## Changes for developers

* New vignette `vignette("options")` describes some developer options (#398).
* Contributors can change the default domain of the API to the URL of a test server via the environmental variable `ETN_TEST_API` (#383).
* Tests make use of `{vcr}` to record and replay HTTP requests to the API. These results are stored in `/tests/fixtures` (#432).
* Tests have new helper functions, including `skip_if_not_localdb()`, `skip_if_http_error()` and `expect_protocol_agnostic()`. The latter is used to compare SQL vs API calls in `test-protocol_agnostic.R` (#436).
* Tests for `download_acoustic_datasets()` are updated for archival tags and SQL vs API calls and makes use of markdown snapshots (#366).
* pkgdown website is now automatically build by a GitHub Action and is served from the `gh-pages` branch. The `docs/` directory has been removed (#456).
* `vignette("acoustic-telemetry")` is precompiled with `vignettes/precompile.R`, so it doesn't run for every build (#473).

## Miscellaneous

* etn now relies on R >= 4.1.0 (because of `{arrow}` and `{vcr}` dependencies) and uses base pipes (`|>` rather than `%>%`) (#327, #384).
* `write_dwc()` now invisibly returns the transformed data as a list of data frames (rather than a data frame) (#302).
* Previously deprecated functions `get_deployments()`, `get_detections()`, `get_projects()`, `get_receivers()`, `list_network_project_codes()` are now removed.
* `vignette("etn_fields")` was outdated and has been removed (#468).

# etn 2.2.2

## Bug fixes

* `check_value()` now correctly formats `NA` values returned by `list_` functions (#356, #357).
* `list_receiver_ids()` no longer return duplicate values (#357).
* `write_dwc()` now handles empty `rights_holder` (#356).

## Miscellaneous

* Tests depending on local database connection are now skipped when it is absent on testing machine (#346).
* Funder is updated and custom authors are removed (#311).
* The README now has a Zenodo badge (#352, #355).
* New `CITATION.cff` file (#337).
* pkgdown website has been updated (#354).

# etn 2.2.1

* `write_dwc()` now supports uppercase `animal_project_code`s (#289).
* `write_dwc()` no longer breaks on updated dependency (#293).

# etn 2.2.0

* `NEWS.md` file is added to communicate changes to the package.
* `depth_in_meters` field is added to `get_acoustic_detections()` (#261).
* `download_acoustic_dataset()` no longer breaks on missing fields in `datapackage.json`.
* Unit tests are stricter (#268).

# etn 2.1.0

* Funder and default README.Rmd are added (#247).
* New function `write_dwc()` transforms acoustic telemetry data to Darwin Core that can be harvested by OBIS and GBIF (#257).

# etn 2.0.0

This releases updates the package to make use of the new model and scope of ETN. Have a look at [this milestone](https://github.com/inbo/etn/milestone/2) for all issues that are included.

* `tag_serial_number` is now the primary identifier for tags. Tags can have multiple types, subtypes and sensors. Acoustic information is related to the `acoustic_tag_id`.
* `acoustic` scope remains completely covered, but is now reflected in function names. This allows us to implement additional scopes (e.g. `cpod`) in the future.
* Old function names are deprecated.
* New `vignette("acoustic-telemetry")` showcases an acoustic use case.
* Test coverage is increased.
