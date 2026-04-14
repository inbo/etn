# Get acoustic project data

Get data for acoustic projects, with options to filter results.

## Usage

``` r
get_acoustic_projects(
  connection,
  acoustic_project_code = NULL,
  citation = FALSE
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- acoustic_project_code:

  Character (vector). One or more acoustic project codes.
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

A tibble with acoustic project data, sorted by `project_code`.

## Examples

``` r
# Get all acoustic projects
get_acoustic_projects()
#> # A tibble: 316 × 11
#>    project_id project_code   project_type telemetry_type project_name start_date
#>         <int> <chr>          <chr>        <chr>          <chr>        <date>    
#>  1        794 2004_Gudena    acoustic     Acoustic       Acoustic re… 2004-01-01
#>  2        761 2011_Loire     acoustic     Acoustic       2011_Loire   2011-11-11
#>  3        755 2011_Warnow    acoustic     Acoustic       Acoustic te… 2011-06-01
#>  4         11 2011_bovensch… acoustic     Acoustic       2011_Bovens… 2011-01-01
#>  5        758 2013_Foyle     acoustic     Acoustic       2013_Foyle   2013-07-01
#>  6         13 2013_Maas      acoustic     Acoustic       2013_Maas    2013-01-01
#>  7        802 2014_Frome     acoustic     Acoustic       2014_Frome   2014-10-01
#>  8        819 2014_Nene      acoustic     Acoustic       2014_Nene    2014-10-31
#>  9        815 2015_PhD_Gutm… acoustic     Acoustic       2015_PhD_Gu… 2015-09-22
#> 10        773 2016_Diaccia_… acoustic     PIT            2016_Diacci… 2016-01-01
#> # ℹ 306 more rows
#> # ℹ 5 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>

# Get a specific acoustic project with citation
get_acoustic_projects(acoustic_project_code = "demer", citation = TRUE)
#> # A tibble: 1 × 16
#>   project_id project_code project_type telemetry_type project_name start_date
#>        <int> <chr>        <chr>        <chr>          <chr>        <date>    
#> 1          7 demer        acoustic     Acoustic       Demer        2014-04-10
#> # ℹ 10 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>, citation <chr>, doi <chr>,
#> #   contact_name <chr>, contact_email <chr>, contact_affiliation <chr>
```
