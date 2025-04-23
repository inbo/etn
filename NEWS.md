# etn (development version)
* API functions now use the `arrow` package to transfer data.frames, which should allow for greater amounts of detections to be transferred without crashing (#323, #327). This will also reduce memory usage for large objects, an should generally result in a speedup.
* etn now requires an R version of at least 4, this is a consequence of the usage of the `arrow` package.

# etn 2.3.0

* **The etn package can now be used on your computer!** It connects to the ETN database with an API provided by the [etnservice](https://github.com/inbo/etnservice) package. All functions make use of this API by default, which may result in **slower response times**. To use the previous method of directly connecting to the database (only possible when working on the [LifeWatch RStudio Server](https://rstudio.lifewatch.be/)), set `api = false` in all functions (#280).
* The `connection` argument is no longer used and therefore deprecated. You will be prompted for credentials instead. Use e.g. `get_animals(animal_id = 305)`, not `get_animals(con, animal_id = 305)` or `get_animals(connection = con, animal_id = 305)` (#301).
* `connect_to_etn()` is no longer necessary and therefore deprecated. All functions will create their own connection when used. If you have no credentials stored in the system environment, the functions will require you to enter them once per session (#303).
* The deprecated functions `get_deployments()`, `get_detections()`, `get_projects()`, `get_receivers()`, `list_network_project_codes()` are no longer included.
* `write_dwc()` now invisibly returns the transformed data as a list of data frames (rather than a data frame) (#302).
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
* New tutorial on acoustic scope ([acoustic_telemetry.Rmd](https://github.com/inbo/etn/blob/main/vignettes/acoustic_telemetry.Rmd)).
