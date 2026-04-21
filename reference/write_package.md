# Write a Data Package to disk

Write a Data Package to disk

## Usage

``` r
write_package(package, directory, compress = FALSE)
```

## Arguments

- package:

  Data Package object, as returned by
  [`read_package()`](https://docs.ropensci.org/frictionless/reference/read_package.html)
  or
  [`create_package()`](https://docs.ropensci.org/frictionless/reference/create_package.html).

- directory:

  Path to local directory to write files to.

- compress:

  If `TRUE`, data of added resources will be gzip compressed before
  being written to disk (e.g. `deployments.csv.gz`).

## See also

Other frictionless functions:
[`read_package()`](https://inbo.github.io/etn/reference/read_package.md)
