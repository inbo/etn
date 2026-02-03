# Get acoustic project data

Get data for acoustic projects, with options to filter results.

## Usage

``` r
get_acoustic_projects(connection, acoustic_project_code = NULL)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- acoustic_project_code:

  Character (vector). One or more acoustic project codes.
  Case-insensitive.

## Value

A tibble with acoustic project data, sorted by `project_code`. See also
[field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).

## Examples

``` r
# Get all acoustic projects
get_acoustic_projects()
#> # A tibble: 303 × 11
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
#> # ℹ 293 more rows
#> # ℹ 5 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>

# Get a specific acoustic project
get_acoustic_projects(acoustic_project_code = "demer")
#> # A tibble: 1 × 11
#>   project_id project_code project_type telemetry_type project_name start_date
#>        <int> <chr>        <chr>        <chr>          <chr>        <date>    
#> 1          7 demer        acoustic     Acoustic       Demer        2014-04-10
#> # ℹ 5 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>
```
