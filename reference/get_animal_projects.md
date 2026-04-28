# Get animal project data

Get data for animal projects, with options to filter results.

## Usage

``` r
get_animal_projects(connection, animal_project_code = NULL, citation = FALSE)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- animal_project_code:

  Character (vector). One or more animal project codes.
  Case-insensitive.

- citation:

  Logical. If `TRUE`, adds extra columns with citation information for
  each project from [MarineInfo](https://marineinfo.org/) using the
  `imis_dataset_id`:

  - `citation`: Formatted citation with DOI if available.

  - `doi`: DOI for the dataset if available.

  - `contact_name`: Contact person, usually the first author. If no
    contact person is provided, the first author with status `creator`.

  - `contact_email`: Email address of the contact person.

  - `contact_affiliation`: Institute of the contact person.

## Value

A tibble with animal project data, sorted by `project_code`.

## See also

Other access functions:
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
# Get all animal projects
get_animal_projects()
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.

# Get a specific animal project with citation
get_animal_projects(animal_project_code = "2014_demer", citation = TRUE)
#> Error in httr2::req_perform(httr2::req_body_json(httr2::req_url_path_append(httr2::request(domain),     "validate_login", "json/"), data = credentials)): HTTP 503 Service Unavailable.
```
