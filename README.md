
<!-- README.md is generated from README.Rmd. Please edit that file -->

# etn <a href="https://inbo.github.io/etn/"><img src="man/figures/logo.png" align="right" height="138" alt="etn website" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/etn)](https://CRAN.R-project.org/package=etn)
[![R-universe
version](https://inbo.r-universe.dev/etn/badges/version)](https://inbo.r-universe.dev/etn)
[![R-CMD-check](https://github.com/inbo/etn/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/inbo/etn/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/inbo/etn/branch/main/graph/badge.svg)](https://app.codecov.io/gh/inbo/etn)
[![repo
status](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15235747.svg)](https://doi.org/10.5281/zenodo.15235747)
<!-- badges: end -->

etn is an R package to access data from the [European Tracking Network
(ETN)](https://www.lifewatch.be/etn/). With etn you can query metadata
(animals, tags, deployments, receivers, projects) and data (acoustic
detections, sensor data) from the ETN database and use these in your
analyses. Data access requires user credentials and is subject to a
[data
policy](https://europeantrackingnetwork.org/en/4-data-policy-permissions-citation-guidelines-and-data-use).

To get started, see:

- [Configure
  credentials](https://inbo.github.io/etn/articles/authentication.html).
- [Function reference](https://inbo.github.io/etn/reference/index.html):
  overview of all functions.
- [Explore acoustic telemetry
  data](https://inbo.github.io/etn/articles/acoustic_telemetry.html).

## Installation

You can install the development version of etn from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("inbo/etn")
```

## Usage

Before you can access data from the European Tracking Network, you need
to register for a MarinePass account at the Flanders Marine Institute
(VLIZ). See
[authentication](https://inbo.github.io/etn/articles/authentication.html#dont-have-an-account-to-etn)
for instructions.

With etn you can query ETN (meta)data:

``` r
library(etn)

# Get animal metadata for a project
get_animals(animal_project_code = "2014_demer")
#> # A tibble: 16 × 66
#>    animal_id animal_project_code tag_serial_number tag_type tag_subtype
#>        <int> <chr>               <chr>             <chr>    <chr>      
#>  1       304 2014_demer          1187449           acoustic animal     
#>  2       384 2014_demer          1157781           acoustic animal     
#>  3       385 2014_demer          1157782           acoustic animal     
#>  4       386 2014_demer          1157783           acoustic animal     
#>  5       305 2014_demer          1187450           acoustic animal     
#>  6       383 2014_demer          1157780           acoustic animal     
#>  7       369 2014_demer          1171781           acoustic animal     
#>  8       370 2014_demer          1171782           acoustic animal     
#>  9       365 2014_demer          1171775           acoustic animal     
#> 10       366 2014_demer          1171776           acoustic animal     
#> 11       368 2014_demer          1171780           acoustic animal     
#> 12       382 2014_demer          1157779           acoustic animal     
#> 13       371 2014_demer          1171783           acoustic animal     
#> 14       372 2014_demer          1171784           acoustic animal     
#> 15       367 2014_demer          1171777           acoustic animal     
#> 16       306 2014_demer          1187468           acoustic animal     
#> # ℹ 61 more variables: acoustic_tag_id <chr>,
#> #   acoustic_tag_id_alternative <chr>, scientific_name <chr>,
#> #   common_name <chr>, aphia_id <int>, animal_label <chr>,
#> #   animal_nickname <chr>, tagger <chr>, capture_date_time <dttm>,
#> #   capture_location <chr>, capture_latitude <dbl>, capture_longitude <dbl>,
#> #   capture_method <chr>, capture_depth <chr>,
#> #   capture_temperature_change <chr>, release_date_time <dttm>, …

# Get acoustic detections for a tag and time period
get_acoustic_detections(
  animal_project_code = "2014_demer",
  # TODO: change to tag_serial_number = "1171781",
  start_date = "2014-06-01",
  end_date = "2014-06-15"
)
#> ℹ Preparing
#> ✔ Preparing : will fetch 15.99 k detections [1.9s]
#> 
#> ℹ Wrapping up
#> ✔ Wrapping up [140ms]
#> 
#> # A tibble: 15,994 × 20
#>    detection_id date_time           tag_serial_number acoustic_tag_id
#>           <int> <dttm>              <chr>             <chr>          
#>  1     20594618 2014-06-04 13:18:45 1187450           A69-1601-16130 
#>  2     20603768 2014-06-04 13:32:32 1187450           A69-1601-16130 
#>  3     20631063 2014-06-04 13:43:26 1187450           A69-1601-16130 
#>  4     20631162 2014-06-04 13:14:13 1187450           A69-1601-16130 
#>  5     20660653 2014-06-03 06:36:00 1187450           A69-1601-16130 
#>  6     20704046 2014-06-04 13:07:48 1187450           A69-1601-16130 
#>  7     20705942 2014-06-04 13:57:01 1187450           A69-1601-16130 
#>  8     20712882 2014-06-04 13:09:10 1187450           A69-1601-16130 
#>  9     20750479 2014-06-04 13:38:35 1187450           A69-1601-16130 
#> 10     20778364 2014-06-04 13:48:37 1187450           A69-1601-16130 
#> # ℹ 15,984 more rows
#> # ℹ 16 more variables: animal_project_code <chr>, animal_id <int>,
#> #   scientific_name <chr>, acoustic_project_code <chr>, receiver_id <chr>,
#> #   station_name <chr>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   sensor_value <dbl>, sensor_unit <chr>, sensor2_value <dbl>,
#> #   sensor2_unit <chr>, signal_to_noise_ratio <int>, source_file <chr>,
#> #   qc_flag <lgl>, deployment_id <int>
```

## Meta

- We welcome [contributions](.github/CONTRIBUTING.md) including bug
  reports.
- License: MIT
- Get citation information for etn in R doing `citation("etn")`.
- Please note that this project is released with a [Contributor Code of
  Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project
  you agree to abide by its terms.
