# Example ETN dataset with river telemetry data

An example ETN dataset "2014_DEMER", with river telemetry data,
formatted as a [Frictionless Data
Package](https://specs.frictionlessdata.io/data-package/) and read by
[`frictionless::read_package()`](https://docs.ropensci.org/frictionless/reference/read_package.html).

## Usage

``` r
river_telemetry
```

## Format

An object of class `datapackage` (inherits from `list`) of length 3.

## Details

["2014_DEMER"](https://www.vliz.be/en/imis?dasid=5871&doiid=432) is a
dataset of acoustic telemetry data collected for four fish species in
the Demer River, Belgium, in 2014. The example dataset is included in
the ETN R package, but can also be downloaded from the ETN database
using the following code:

`download_acoustic_dataset( animal_project_code = "2014_demer", directory = here::here("inst", "extdata") )`

## Examples

``` r
if (FALSE) { # \dontrun{
# The data in river_telemetry was created with the code below
package_path <- system.file("extdata", "datapackage.json", package = "etn")
river_telemetry <- read_package(package_path)
usethis::use_data(river_telemetry, overwrite = TRUE)
} # }
```
