# Get tag data

Get data for tags, with options to filter results. Note that there can
be multiple records (`acoustic_tag_id`) per tag device
(`tag_serial_number`).

## Usage

``` r
get_tags(
  connection,
  tag_type = NULL,
  tag_subtype = NULL,
  tag_serial_number = NULL,
  acoustic_tag_id = NULL
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- tag_type:

  Character (vector). `acoustic` or `archival`. Some tags are both, find
  those with `acoustic-archival`.

- tag_subtype:

  Character (vector). `animal`, `built-in`, `range` or `sentinel`.

- tag_serial_number:

  Character (vector). One or more tag serial numbers.

- acoustic_tag_id:

  Character (vector). One or more acoustic tag identifiers, i.e.
  identifiers found in
  [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md).

## Value

A tibble with tags data, sorted by `tag_serial_number`. Values for
`owner_organization` and `owner_pi` will only be visible if you are
member of the group.

## See also

Other access functions:
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md)

## Examples

``` r
# Get all tags
get_tags()
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get archival tags, including acoustic-archival
get_tags(tag_type = c("archival", "acoustic-archival"))
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get tags of specific subtype
get_tags(tag_subtype = c("built-in", "range"))
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get specific tags (note that these can return multiple records)
get_tags(tag_serial_number = "1187450")
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
get_tags(acoustic_tag_id = "A69-1601-16130")
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
get_tags(acoustic_tag_id = c("A69-1601-16129", "A69-1601-16130"))
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
```
