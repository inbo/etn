# etn (development version)

## Use etn on your computer 🎉

* etn now connects to the ETN database with an API provided by the [etnservice](https://github.com/inbo/etnservice) package (#280). This means you can use the package from your own computer. Note that this will be slower than running it from the [VLIZ RStudio server](http://rstudio.lifewatch.be/).
* etn will automatically switch to a local database connection when available (e.g. the VLIZ RStudio server). Use `Sys.setenv(ETN_PROTOCOL = "opencpu")` to override this behaviour and force the package to use the API (#398).
* Queries via the API and the VLIZ RStudio Server will return the same results (#317).
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

1. Follow the steps in `vignette("authentication")` to look up and store your credentials.
2. Update your scripts:

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

## Developer settings

* Contributors can change the default domain of the API to the url of a test deployment by setting the environmental variable `ETN_TEST_API` (#383).
* New vignette `vignette("options")` describes some developer/power user options (#398).

## Miscellaneous

* etn now relies on R >= 4.1.0 (because of vcr dependency) and uses base pipes (`|>` rather than `%>%`) (#384).
* `write_dwc()` now invisibly returns the transformed data as a list of data frames (rather than a data frame) (#302).
* Previously deprecated functions `get_deployments()`, `get_detections()`, `get_projects()`, `get_receivers()`, `list_network_project_codes()` are now removed.

# etn 2.2.2

* Fix issue in `check_value()` helper used in several functions to generate error messages. The error message failed to format when `NA` values were returned as part of a `list_` function call (#356).
* Fix issue in `list_receiver_ids()` where `NA` was sometimes included in the results (#356).
* Fixed bug in `write_dwc()` where providing no value for `rights_holder` would result in the function failing to generate a Darwin Core Archive (#356).

# etn 2.2.1

* `write_dwc()` now supports uppercase `animal_project_code`s (#289).
* Bug fix in `write_dwc()` where the function would return an error due to an updated dependency (#293).

# etn 2.2.0

* Add `NEWS.md` file to communicate changes to the package.
* Add `depth_in_meters` field to `get_acoustic_detections()` (#261).
* Fix issue in `download_acoustic_dataset()` where some fields were missing from `datapackage.json`.
* Stricter unit tests (#268).

# etn 2.1.0

* Add funder and use default README.Rmd (#247).
* New function `write_dwc()` to transform acoustic telemetry data to Darwin Core that can be harvested by OBIS and GBIF (#257).

# etn 2.0.0

This releases updates the package to make use of the new model and scope of ETN. Have a look at [this milestone](https://github.com/inbo/etn/milestone/2) for all issues that are included.

* `tag_serial_number` is now the primary identifier for tags. Tags can have multiple types, subtypes and sensors. Acoustic information is related to the `acoustic_tag_id`.
* `acoustic` scope remains completely covered, but is now reflected in function names. This allows us to implement additional scopes (e.g. `cpod`) in the future.
* Deprecations for old function names.
* New tutorial on acoustic scope ([acoustic-telemetry.Rmd](https://github.com/inbo/etn/blob/main/vignettes/acoustic-telemetry.Rmd)).
