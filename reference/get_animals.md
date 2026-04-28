# Get animal data

Get data for animals, with options to filter results. Associated tag
information is available in columns starting with `tag` and
`acoustic_tag_id`. If multiple tags are associated with a single animal,
the information is comma-separated.

## Usage

``` r
get_animals(
  connection,
  animal_id = NULL,
  tag_serial_number = NULL,
  animal_project_code = NULL,
  scientific_name = NULL
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- animal_id:

  Integer (vector). One or more animal identifiers.

- tag_serial_number:

  Character (vector). One or more tag serial numbers.

- animal_project_code:

  Character (vector). One or more animal project codes.
  Case-insensitive.

- scientific_name:

  Character (vector). One or more scientific names.

## Value

A tibble with animals data, sorted by `animal_project_code`,
`release_date_time` and `tag_serial_number`.

## See also

Other access functions:
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
# Get all animals
get_animals()
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get specific animals
get_animals(animal_id = 305) # Or string value "305"
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
get_animals(animal_id = c(304, 305, 2827))
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get animals from specific animal project(s)
get_animals(animal_project_code = "2014_demer")
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
get_animals(animal_project_code = c("2014_demer", "2015_dijle"))
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get animals associated with a specific tag_serial_number
get_animals(tag_serial_number = "1187450")
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get animals of specific species (across all projects)
get_animals(scientific_name = c("Rutilus rutilus", "Silurus glanis"))
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get animals of a specific species from a specific project
get_animals(animal_project_code = "2014_demer", scientific_name = "Rutilus rutilus")
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
```
