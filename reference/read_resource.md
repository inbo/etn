# Read data from a Data Resource into a tibble data frame

Read data from a Data Resource into a tibble data frame

## Usage

``` r
read_resource(package, resource_name, col_select = NULL)
```

## Arguments

- package:

  Data Package object, as returned by
  [`read_package()`](https://docs.ropensci.org/frictionless/reference/read_package.html)
  or
  [`create_package()`](https://docs.ropensci.org/frictionless/reference/create_package.html).

- resource_name:

  Name of the Data Resource.

- col_select:

  Character vector of the columns to include in the result, in the order
  provided. Selecting columns can improve read speed.

## See also

Other frictionless functions:
[`read_package`](https://inbo.github.io/etn/reference/read_package.md),
[`write_package`](https://inbo.github.io/etn/reference/write_package.md)
