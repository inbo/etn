# Read an example dataset

Reads an example dataset, formatted as a [Frictionless Data
Package](https://specs.frictionlessdata.io/data-package/).

## Usage

``` r
example_dataset(dataset = "2014_DEMER")
```

## Arguments

- dataset:

  Name of the example dataset to load. Defaults to the only available
  dataset: `"2014_DEMER"`.

## Value

Frictionless data package.

## 2014_DEMER

`2014_DEMER` is a **river acoustic telemetry** dataset. It contains 66
tagged animals across four species. Over 235,000 detections were
observed between 2014 and 2019 by acoustic receivers deployed in Belgian
rivers.

Data are deposited at <https://doi.org/10.14284/432> and can be
downloaded from the ETN database with
`download_acoustic_dataset(animal_project_code = "2014_DEMER")`.

## Examples

``` r
example_dataset()
#> A Data Package with 5 resources:
#> • animals
#> • tags
#> • detections
#> • deployments
#> • receivers
#> Use `unclass()` to print the Data Package as a list.
```
