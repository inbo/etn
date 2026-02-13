
<!-- README.md is generated from README.Rmd. Please edit that file -->

# etn <img src="man/figures/logo.png" align="right" alt="" width="120">

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

Etn provides functionality to access data from the [European Tracking
Network (ETN)](https://www.lifewatch.be/etn/) database hosted by the
Flanders Marine Institute (VLIZ) as part of the Flemish contribution to
LifeWatch. ETN data is subject to the [ETN data
policy](https://www.lifewatch.be/etn/assets/docs/ETN-DataPolicy.pdf) and
can be:

- restricted: under moratorium and only accessible to logged-in data
  owners/collaborators
- unrestricted: publicly accessible without login and routinely
  published to international biodiversity facilities

## Installation

You can install the development version of etn from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("inbo/etn")
```

If you want, you can also install etn directly from the [inbo
r-universe](https://inbo.r-universe.dev):

``` r
# Enable the inbo r-universe
options(repos = c(
    inbo = 'https://inbo.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'))

# Install etn
install.packages("etn")
```

You can read more about the r-universe platform
[here](https://ropensci.org/r-universe/).

## Example

Before you can access data from the European Tracking Network, you need
to request a login from the Flanders Marine Institute (VLIZ). A detailed
description on how to do this can be found in the vignette on
[authentication](articles/authentication.html#dont-have-an-account-to-etn).

This is a basic example which shows you how to solve a common problem:

``` r
library(etn)
# Get data for animal with animal_id 740
get_animals(animal_id = 740) |> dplyr::glimpse()
#> Rows: 1
#> Columns: 66
#> $ animal_id                                  <int> 740
#> $ animal_project_code                        <chr> "2010_phd_reubens_sync"
#> $ tag_serial_number                          <chr> "1097352"
#> $ tag_type                                   <chr> "acoustic"
#> $ tag_subtype                                <chr> "sentinel"
#> $ acoustic_tag_id                            <chr> "A69-1303-65309"
#> $ acoustic_tag_id_alternative                <chr> "R64K-65309"
#> $ scientific_name                            <chr> "Sync tag"
#> $ common_name                                <chr> NA
#> $ aphia_id                                   <int> NA
#> $ animal_label                               <chr> "S08"
#> $ animal_nickname                            <chr> NA
#> $ tagger                                     <chr> ""
#> $ capture_date_time                          <dttm> 2010-08-05
#> $ capture_location                           <chr> NA
#> $ capture_latitude                           <dbl> NA
#> $ capture_longitude                          <dbl> NA
#> $ capture_method                             <chr> NA
#> $ capture_depth                              <chr> NA
#> $ capture_temperature_change                 <chr> NA
#> $ release_date_time                          <dttm> 2010-08-05
#> $ release_location                           <chr> "R08"
#> $ release_latitude                           <dbl> 51.5469
#> $ release_longitude                          <dbl> 2.92828
#> $ recapture_date_time                        <dttm> 2011-03-11
#> $ length1_type                               <chr> NA
#> $ length1                                    <dbl> NA
#> $ length1_unit                               <chr> NA
#> $ length2_type                               <chr> NA
#> $ length2                                    <dbl> NA
#> $ length2_unit                               <chr> NA
#> $ length3_type                               <chr> NA
#> $ length3                                    <dbl> NA
#> $ length3_unit                               <chr> NA
#> $ length4_type                               <chr> NA
#> $ length4                                    <dbl> NA
#> $ length4_unit                               <chr> NA
#> $ weight                                     <dbl> NA
#> $ weight_unit                                <chr> NA
#> $ age                                        <dbl> NA
#> $ age_unit                                   <chr> NA
#> $ sex                                        <chr> "unknown"
#> $ life_stage                                 <chr> NA
#> $ wild_or_hatchery                           <chr> NA
#> $ stock                                      <chr> NA
#> $ surgery_date_time                          <dttm> NA
#> $ surgery_location                           <chr> NA
#> $ surgery_latitude                           <dbl> NA
#> $ surgery_longitude                          <dbl> NA
#> $ treatment_type                             <chr> NA
#> $ tagging_type                               <chr> ""
#> $ tagging_methodology                        <chr> ""
#> $ dna_sample                                 <chr> NA
#> $ sedative                                   <chr> NA
#> $ sedative_concentration                     <chr> NA
#> $ anaesthetic                                <chr> NA
#> $ buffer                                     <chr> NA
#> $ anaesthetic_concentration                  <chr> NA
#> $ buffer_concentration_in_anaesthetic        <chr> NA
#> $ anaesthetic_concentration_in_recirculation <chr> NA
#> $ buffer_concentration_in_recirculation      <chr> NA
#> $ dissolved_oxygen                           <chr> NA
#> $ pre_surgery_holding_period                 <chr> NA
#> $ post_surgery_holding_period                <chr> NA
#> $ holding_temperature                        <chr> NA
#> $ comments                                   <chr> NA
# Get detections for the associated tag for a certain period
get_acoustic_detections(tag_serial_number = "1097352",
                        start_date = "2011-01-01",
                        end_date = "2011-01-15")
#> ℹ Preparing
#> ✔ Preparing : will fetch 2.16 k detections [1.5s]
#> 
#> ℹ Wrapping up
#> ✔ Wrapping up [160ms]
#> 
#> # A tibble: 2,163 × 20
#>    detection_id date_time           tag_serial_number acoustic_tag_id
#>           <int> <dttm>              <chr>             <chr>          
#>  1     19148203 2011-01-01 20:39:29 1097352           A69-1303-65309 
#>  2     19148209 2011-01-02 03:12:09 1097352           A69-1303-65309 
#>  3     19148225 2011-01-02 15:57:20 1097352           A69-1303-65309 
#>  4     19148243 2011-01-03 09:44:34 1097352           A69-1303-65309 
#>  5     19148249 2011-01-03 15:47:02 1097352           A69-1303-65309 
#>  6     19148251 2011-01-03 16:07:10 1097352           A69-1303-65309 
#>  7     19397680 2011-01-01 07:25:58 1097352           A69-1303-65309 
#>  8     19397708 2011-01-01 09:16:42 1097352           A69-1303-65309 
#>  9     19397853 2011-01-01 19:40:58 1097352           A69-1303-65309 
#> 10     19475436 2011-01-01 03:14:41 1097352           A69-1303-65309 
#> # ℹ 2,153 more rows
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
