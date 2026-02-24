# Get animal project data

Get data for animal projects, with options to filter results.

## Usage

``` r
get_animal_projects(connection, animal_project_code = NULL)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- animal_project_code:

  Character (vector). One or more animal project codes.
  Case-insensitive.

## Value

A tibble with animal project data, sorted by `project_code`. See also
[field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).

## Examples

``` r
# Get all animal projects
get_animal_projects()
#> # A tibble: 350 × 11
#>    project_id project_code   project_type telemetry_type project_name start_date
#>         <int> <chr>          <chr>        <chr>          <chr>        <date>    
#>  1        793 2004_Gudena    animal       Acoustic       Silver eel … 2004-01-01
#>  2         16 2010_phd_reub… animal       Acoustic       2010_phd_re… 2010-08-01
#>  3        841 2010_phd_reub… animal       Acoustic       2010_phd_re… 2010-08-01
#>  4        760 2011_Loire     animal       Acoustic       2011_Loire   2011-11-11
#>  5        754 2011_Warnow    animal       Acoustic       Silver eel … 2011-06-01
#>  6         20 2011_rivierpr… animal       Acoustic       2011 Rivier… 2011-01-01
#>  7         15 2012_leopoldk… animal       Acoustic       2012 Leopol… 2012-01-01
#>  8        757 2013_Foyle     animal       Acoustic       2013_Foyle   2013-07-01
#>  9         18 2013_albertka… animal       Acoustic       2013 Albert… 2013-10-10
#> 10        801 2014_Frome     animal       NA             2014_Frome   2014-10-01
#> # ℹ 340 more rows
#> # ℹ 5 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>

# Get a specific animal project
get_animal_projects(animal_project_code = "2014_demer")
#> # A tibble: 1 × 11
#>   project_id project_code project_type telemetry_type project_name start_date
#>        <int> <chr>        <chr>        <chr>          <chr>        <date>    
#> 1         21 2014_demer   animal       Acoustic       2014 Demer   2014-04-10
#> # ℹ 5 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>
```
