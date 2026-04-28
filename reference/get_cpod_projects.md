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
#> # A tibble: 19 × 11
#>    project_id project_code   project_type telemetry_type project_name start_date
#>         <int> <chr>          <chr>        <chr>          <chr>        <date>    
#>  1       1088 ARMS_MBON_Bel… cpod         NA             Underwater … 2018-07-12
#>  2        880 Apelafico_aco… cpod         NA             Apelafico_a… 2021-01-01
#>  3        973 Apelafico_und… cpod         NA             Acoustic Ec… 2021-01-01
#>  4       1093 CODEVCO        cpod         NA             CODEVCO - m… 2021-10-31
#>  5       1186 Lifewatch_ext… cpod         NA             Lifewatch: … 2025-05-01
#>  6       1185 Lifewatch_test cpod         NA             Lifewatch: … 2025-03-26
#>  7       1318 NOVANA         cpod         NA             The Nationa… 2004-01-01
#>  8       1073 PAM-Borssele   cpod         NA             PAM Harbour… 2019-07-01
#>  9       1066 PelFish        cpod         NA             Duurzame ec… 2023-01-01
#> 10        948 PhD_Parcerisas cpod         NA             PhD_Parceri… 2021-03-09
#> 11       1094 PureWind       cpod         NA             Noise impac… 2023-01-01
#> 12       1063 SEAWave        cpod         NA             SEAWave: sm… 2021-08-20
#> 13        902 SMGMIT         cpod         Acoustic       SeaMonitor … 2019-04-10
#> 14       1079 STRAITS_PAM    cpod         NA             Passive Aco… 2023-01-02
#> 15        838 VLIZ-MRC-AMUC… cpod         NA             VLIZ-MRC-AM… NA        
#> 16        839 VLIZ-MRC-AMUC… cpod         NA             VLIZ-MRC-AM… NA        
#> 17       1062 WaveHub        cpod         NA             Wave Hub: u… 2011-01-01
#> 18        638 cpod-lifewatch cpod         NA             Lifewatch    2015-06-01
#> 19        639 cpod-od-natuur cpod         NA             WinMon.be_C… 2010-01-01
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
