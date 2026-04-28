# Read an example dataset

Reads an example dataset, formatted as a [Frictionless Data
Package](https://specs.frictionlessdata.io/data-package/).

## Usage

``` r
example_dataset(dataset = "2014_demer")
```

## Arguments

- dataset:

  Name of the example dataset to load. Defaults to the only available
  dataset: `"2014_DEMER"`.

## Value

Frictionless data package.

## 2014_demer

`2014_demer` is a **river acoustic telemetry** dataset. It contains 66
tagged animals across four species. Over 235,000 detections were
observed between 2014 and 2019 by acoustic receivers deployed in Belgian
rivers. Data are deposited at <https://doi.org/10.14284/432>.

The dataset was included in the package with:

    get_package(animal_project_code = "2014_demer") |>
      write_package("inst/extdata/2014_demer")

After which the `detections.csv` file was compressed and its path
manually updated in `datapackage.json`.

## Examples

``` r
example_dataset()
#> A Data Package with 5 resources:
#> • animals
#> • tags
#> • detections
#> • deployments
#> • receivers
#> For more information, see <https://doi.org/10.14284/432>.
#> Use `unclass()` to print the Data Package as a list.
```
