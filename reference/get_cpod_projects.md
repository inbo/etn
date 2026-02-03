# Get cpod project data

Get data for cpod projects, with options to filter results.

## Usage

``` r
get_cpod_projects(connection, cpod_project_code = NULL)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- cpod_project_code:

  Character (vector). One or more cpod project codes. Case-insensitive.

## Value

A tibble with animal project data, sorted by `project_code`. See also
[field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).

## Examples

``` r
# Get all animal projects
get_cpod_projects()
#> # A tibble: 18 × 11
#>    project_id project_code   project_type telemetry_type project_name start_date
#>         <int> <chr>          <chr>        <chr>          <chr>        <date>    
#>  1       1088 ARMS_MBON_Bel… cpod         NA             Underwater … 2018-07-12
#>  2        880 Apelafico_aco… cpod         NA             Apelafico_a… 2021-01-01
#>  3        973 Apelafico_und… cpod         NA             Acoustic Ec… 2021-01-01
#>  4       1093 CODEVCO        cpod         NA             CODEVCO - m… 2021-10-31
#>  5       1186 Lifewatch_ext… cpod         NA             Lifewatch: … 2025-05-01
#>  6       1185 Lifewatch_test cpod         NA             Lifewatch: … 2025-03-26
#>  7       1073 PAM-Borssele   cpod         NA             PAM Harbour… 2019-07-01
#>  8       1066 PelFish        cpod         NA             Duurzame ec… 2023-01-01
#>  9        948 PhD_Parcerisas cpod         NA             PhD_Parceri… 2021-03-09
#> 10       1094 PureWind       cpod         NA             Noise impac… 2023-01-01
#> 11       1063 SEAWave        cpod         NA             SEAWave: sm… 2021-08-20
#> 12        902 SMGMIT         cpod         Acoustic       SeaMonitor … 2019-04-10
#> 13       1079 STRAITS_PAM    cpod         NA             Passive Aco… 2023-01-02
#> 14        838 VLIZ-MRC-AMUC… cpod         NA             VLIZ-MRC-AM… NA        
#> 15        839 VLIZ-MRC-AMUC… cpod         NA             VLIZ-MRC-AM… NA        
#> 16       1062 WaveHub        cpod         NA             Wave Hub: u… 2011-01-01
#> 17        638 cpod-lifewatch cpod         NA             Lifewatch    2015-06-01
#> 18        639 cpod-od-natuur cpod         NA             WinMon.be_C… 2010-01-01
#> # ℹ 5 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>

# Get a specific animal project
get_cpod_projects(cpod_project_code = "cpod-lifewatch")
#> # A tibble: 1 × 11
#>   project_id project_code   project_type telemetry_type project_name start_date
#>        <int> <chr>          <chr>        <chr>          <chr>        <date>    
#> 1        638 cpod-lifewatch cpod         NA             Lifewatch    2015-06-01
#> # ℹ 5 more variables: end_date <date>, latitude <dbl>, longitude <dbl>,
#> #   moratorium <lgl>, imis_dataset_id <int>
```
