# Get animal project data as a Data Package

Gets all data related to an **animal project** as a [Data
Package](https://specs.frictionlessdata.io/data-package/).

## Usage

``` r
get_package(animal_project_code)
```

## Arguments

- animal_project_code:

  Animal project you want to get data from.

## Value

A Data Package object. Write it to disk with
[`write_package()`](https://inbo.github.io/etn/reference/write_package.md).

## Included resources

The Data Package will contain and describe the following resources:

- `animals`: Animals related to an `animal_project_code`, as returned by
  [`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md).

- `tags`: Tags associated with the selected animals, as returned by
  [`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md).

- `detections`: Acoustic detections for the selected animals, as
  returned by
  [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md).

- `deployments`: Acoustic deployments for the `acoustic_project_code`(s)
  found in detections, as returned by
  [`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md).
  This allows you to see when receivers were deployed, even if these did
  not detect the selected animals.

- `receivers`: Acoustic receivers for the selected deployments, as
  returned by
  [`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md).

## Data quality

The data are downloaded from the ETN database *as is*, i.e. no quality
or consistency checks are performed. Verifying the data before
publication is therefore recommended. You can validate the technical
consistency of your Data Package using [Frictionless
Framework](https://framework.frictionlessdata.io/) with:

    pip install frictionless
    frictionless validate datapackage.json

## See also

Other access functions:
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
if (FALSE) { # etn:::credentials_are_set() & interactive()
# Get a Data Package for a project
get_package(animal_project_code = "2014_demer")
}
```
