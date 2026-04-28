# Get acoustic deployment data

Get data for deployments of acoustic receivers, with options to filter
results.

## Usage

``` r
get_acoustic_deployments(
  connection,
  deployment_id = NULL,
  receiver_id = NULL,
  acoustic_project_code = NULL,
  station_name = NULL,
  open_only = FALSE
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- deployment_id:

  Integer (vector). One or more deployment identifiers.

- receiver_id:

  Character (vector). One or more receiver identifiers.

- acoustic_project_code:

  Character (vector). One or more acoustic project codes.
  Case-insensitive.

- station_name:

  Character (vector). One or more deployment station names.

- open_only:

  Logical. Restrict deployments to those that are currently open (i.e.
  no end date defined). Defaults to `FALSE`.

## Value

A tibble with acoustic deployment data, sorted by
`acoustic_project_code`, `station_name` and `deploy_date_time`.

## See also

Other access functions:
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
# Get all acoustic deployments
get_acoustic_deployments()
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get specific acoustic deployment
get_acoustic_deployments(deployment_id = 1437)
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get acoustic deployments for a specific receiver
get_acoustic_deployments(receiver_id = "VR2W-124070")
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get open acoustic deployments for a specific receiver
get_acoustic_deployments(receiver_id = "VR2W-124070", open_only = TRUE)
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get acoustic deployments for a specific acoustic project
get_acoustic_deployments(acoustic_project_code = "demer")
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get acoustic deployments for two specific stations
get_acoustic_deployments(station_name = c("de-9", "de-10"))
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
```
