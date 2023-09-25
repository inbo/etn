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
