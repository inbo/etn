# Get acoustic receiver data

Get data for acoustic receivers, with options to filter results.

## Usage

``` r
get_acoustic_receivers(connection, receiver_id = NULL, status = NULL)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- receiver_id:

  Character (vector). One or more receiver identifiers.

- status:

  Character. One or more statuses, e.g. `available` or `broken`.

## Value

A tibble with acoustic receiver data, sorted by `receiver_id`. Values
for `owner_organization` will only be visible if you are member of the
group.

## See also

Other access functions:
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
# Get all acoustic receivers
get_acoustic_receivers()
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get lost and broken acoustic receivers
get_acoustic_receivers(status = c("lost", "broken"))
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get a specific acoustic receiver
get_acoustic_receivers(receiver_id = "VR2W-124070")
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
```
