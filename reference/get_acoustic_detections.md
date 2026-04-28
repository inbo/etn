# Get acoustic detections data

Get data for acoustic detections, with options to filter results. Use
`limit` to limit the number of returned records.

## Usage

``` r
get_acoustic_detections(
  connection,
  start_date = NULL,
  end_date = NULL,
  tag_serial_number = NULL,
  acoustic_tag_id = NULL,
  animal_project_code = NULL,
  scientific_name = NULL,
  acoustic_project_code = NULL,
  receiver_id = NULL,
  station_name = NULL,
  limit = FALSE,
  progress = TRUE
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- start_date:

  Character. Start date (inclusive) in ISO 8601 format ( `yyyy-mm-dd`,
  `yyyy-mm` or `yyyy`).

- end_date:

  Character. End date (exclusive) in ISO 8601 format ( `yyyy-mm-dd`,
  `yyyy-mm` or `yyyy`).

- tag_serial_number:

  Character (vector). One or more acoustic tag serial numbers.

- acoustic_tag_id:

  Character (vector). One or more acoustic tag ids.

- animal_project_code:

  Character (vector). One or more animal project codes.
  Case-insensitive.

- scientific_name:

  Character (vector). One or more scientific names.

- acoustic_project_code:

  Character (vector). One or more acoustic project codes.
  Case-insensitive.

- receiver_id:

  Character (vector). One or more receiver identifiers.

- station_name:

  Character (vector). One or more deployment station names.

- limit:

  Logical. Limit the number of returned records to 100 (useful for
  testing purposes). Defaults to `FALSE`.

- progress:

  Logical. Show a progress bar while fetching data. Defaults to `TRUE`.

## Value

A tibble with acoustic detections data, sorted by `acoustic_tag_id` and
`date_time`.

## See also

Other access functions:
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
# Get limited sample of acoustic detections
get_acoustic_detections(limit = TRUE)
#> ℹ Preparing 
#> ✔ Preparing : will fetch 100  detections [12ms]
#> 
#> Error in value[[3L]](cond): Server side error
#> • Please try again.
#> • If the error persists, please report it to the package authors

# Get all acoustic detections from a specific animal project
get_acoustic_detections(animal_project_code = "2014_demer")
#> ℹ Preparing 
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
#> ✖ Preparing  [1.4s]
#> 

# Get 2015 acoustic detections from that animal project
get_acoustic_detections(
  animal_project_code = "2014_demer",
  start_date = "2015",
  end_date = "2016",
)
#> ℹ Preparing 
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
#> ✖ Preparing  [1.2s]
#> 

# Get April 2015 acoustic detections from that animal project
get_acoustic_detections(
  animal_project_code = "2014_demer",
  start_date = "2015-04",
  end_date = "2015-05",
)
#> ℹ Preparing 
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
#> ✖ Preparing  [1.1s]
#> 

# Get April 24, 2015 acoustic detections from that animal project
get_acoustic_detections(
  animal_project_code = "2014_demer",
  start_date = "2015-04-24",
  end_date = "2015-04-25",
)
#> ℹ Preparing 
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
#> ✖ Preparing  [1.2s]
#> 

# Get acoustic detections for a specific tag at two specific stations
get_acoustic_detections(
  acoustic_tag_id = "A69-1601-16130",
  station_name = c("de-9", "de-10")
)
#> ℹ Preparing 
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
#> ✖ Preparing  [1.1s]
#> 

# Get acoustic detections for a specific species, receiver and acoustic project
get_acoustic_detections(
  scientific_name = "Rutilus rutilus",
  receiver_id = "VR2W-124070",
  acoustic_project_code = "demer"
)
#> ℹ Preparing 
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
#> ✖ Preparing  [1.1s]
#> 
```
