# Get processed tag archival data

Fetches processed archival data from tags. The data downloaded from csv
files hosted on lifewatch.com and then read into R. Providing at least
one of the following arguments is required: `tag_serial_number`,
`animal_id`, or `animal_project_code`.

## Usage

``` r
get_archival_data(
  tag_serial_number = NULL,
  animal_id = NULL,
  animal_project_code = NULL,
  path = NULL,
  limit = FALSE,
  progress = TRUE,
  return_as = c("tibble", "arrow")
)
```

## Arguments

- tag_serial_number:

  Character (vector). One or more tag serial numbers.

- animal_id:

  Integer (vector). One or more animal identifiers.

- animal_project_code:

  **\[experimental\]** Character (vector). One or more animal project
  codes. Case-insensitive. An animal project can contain many gigabytes
  of archival data. Downloading this data may take a while and exceed
  the available RAM or Storage of your computer.

- path:

  **\[experimental\]** Character. A path to an existing directory where
  the csv files will be stored. If NULL, the csv files will be stored in
  a temporary directory that is deleted when R is restarted.

- limit:

  Logical. Limit the number of returned records to 100 (useful for
  testing purposes). Defaults to `FALSE`.

- progress:

  Logical. Show a progress bar while fetching data. Defaults to `TRUE`.

- return_as:

  **\[experimental\]** Character. One of "tibble" or "arrow". Whether to
  return the data as an in memory tibble or an out of memory arrow
  dataset. The latter is recommended for large datasets, but requires
  more disk space and may be slower to query. When selecting "arrow"
  keep in mind that the downloaded data will remain stored on your
  computer until R is restarted.

## Value

Depending on the value of `return_as`, either an
[arrow::Dataset](https://arrow.apache.org/docs/r/reference/Dataset.html)
or a data.frame with the archival data values. The resulting table has
the following columns:

- `tag_id`: The tag id of the tag that recorded the data.

- `timestamp_utc`: The timestamp of the measurement in UTC.

- `measurement_type`: The type of measurement (e.g. "Temp", "Pressure,
  etc.).

- `measurement_value`: The value of the measurement.

- `measurement_unit`: The unit of the measurement (e.g. "C", "Pa",
  etc.).

- `animal_project_code`: The animal project code of the animal that
  recorded the data.

- `animal_id`: The animal id of the animal the tag was attached to.

- `tag_serial_number`: The tag serial number of the tag that recorded
  the data.

## Returning large amounts of data out of memory

If you are fetching a large amount of data, it is recommended to use
`return_as = "arrow"` to return an out of memory object. This will allow
you to query the data without loading it all into memory at once. Keep
in mind that the downloaded data will remain stored on your computer
until R is restarted. If you want to keep the data, you can provide a
path to an existing directory where the csv files will be stored via the
`path` argument. See
[arrow::Dataset](https://arrow.apache.org/docs/r/reference/Dataset.html)
for more information.

## Temporary storage of csv files

When `return_as` is set to `arrow`, the downloaded csv fils will be
stored in [`tempdir()`](https://rdrr.io/r/base/tempfile.html) even when
no `path` has been provided. This is neccesairy because of the way arrow
dataasetquery objects work; they need to be able to access the csv files
on disk. To remove these files from your computer, you can either
restart R or manually delete the files from the temporary directory.

## See also

Other access functions:
[`get_acoustic_deployment_logs()`](https://inbo.github.io/etn/reference/get_acoustic_deployment_logs.md),
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_bibliography()`](https://inbo.github.io/etn/reference/get_bibliography.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
if (FALSE) { # interactive() & etn:::credentials_are_set()
  get_archival_data(tag_serial_number = "A15757", limit = TRUE)
}
```
