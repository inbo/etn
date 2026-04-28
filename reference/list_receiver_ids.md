# List all available receiver ids

List all available receiver ids

## Usage

``` r
list_receiver_ids(connection)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

## Value

A vector of all unique `receiver` present in `acoustic.receivers`.

## See also

Other list functions:
[`list_acoustic_project_codes()`](https://inbo.github.io/etn/reference/list_acoustic_project_codes.md),
[`list_acoustic_tag_ids()`](https://inbo.github.io/etn/reference/list_acoustic_tag_ids.md),
[`list_animal_ids()`](https://inbo.github.io/etn/reference/list_animal_ids.md),
[`list_animal_project_codes()`](https://inbo.github.io/etn/reference/list_animal_project_codes.md),
[`list_cpod_project_codes()`](https://inbo.github.io/etn/reference/list_cpod_project_codes.md),
[`list_deployment_ids()`](https://inbo.github.io/etn/reference/list_deployment_ids.md),
[`list_scientific_names()`](https://inbo.github.io/etn/reference/list_scientific_names.md),
[`list_station_names()`](https://inbo.github.io/etn/reference/list_station_names.md),
[`list_tag_serial_numbers()`](https://inbo.github.io/etn/reference/list_tag_serial_numbers.md),
[`list_values()`](https://inbo.github.io/etn/reference/list_values.md)

## Examples

``` r
list_receiver_ids()
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
```
