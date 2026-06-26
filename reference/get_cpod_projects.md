# Get cpod project data

Get data for cpod projects, with options to filter results.

## Usage

``` r
get_cpod_projects(connection, cpod_project_code = NULL, citation = FALSE)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- cpod_project_code:

  Character (vector). One or more cpod project codes. Case-insensitive.

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
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
# Get all animal projects
get_cpod_projects()
#> # A tibble: 22 × 11
#>    project_id project_code   project_type telemetry_type project_name start_date
#>         <int> <chr>          <chr>        <chr>          <chr>        <date>    
#>  1       1088 ARMS_MBON_Bel… cpod         NA             Underwater … 2018-07-12
#>  2        880 Apelafico_aco… cpod         NA             Apelafico_a… 2021-01-01
#>  3        973 Apelafico_und… cpod         NA             Acoustic Ec… 2021-01-01
#>  4       1337 Blueconnect    cpod         NA             BlueConnect… 2026-01-01
#>  5       1093 CODEVCO        cpod         NA             CODEVCO - m… 2021-10-31
#>  6       1186 Lifewatch_add… cpod         NA             Lifewatch: … 2025-05-01
#>  7       1185 Lifewatch_per… cpod         NA             Lifewatch: … 2025-03-26
#>  8       1318 NOVANA         cpod         NA             The Nationa… 2004-01-01
#>  9       1073 PAM-Borssele   cpod         NA             PAM Harbour… 2019-07-01
#> 10       1066 PelFish        cpod         NA             Duurzame ec… 2023-01-01
#> # ℹ 12 more rows
#> # ℹ 5 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>

# Get a specific animal project with citation
get_cpod_projects(cpod_project_code = "cpod-lifewatch", citation = TRUE)
#> # A tibble: 1 × 16
#>   project_id project_code   project_type telemetry_type project_name start_date
#>        <int> <chr>          <chr>        <chr>          <chr>        <date>    
#> 1        638 cpod-lifewatch cpod         NA             Lifewatch    2015-06-01
#> # ℹ 10 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>, citation <chr>, doi <chr>,
#> #   contact_name <chr>, contact_email <chr>, contact_affiliation <chr>
```
