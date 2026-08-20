# Create bibliography from detections

Creates a bibliography from a table of detections, with references for:

- The ETN data platform.

- The etn R package.

- Animal project(s) associated with the animals that were detected.

- Acoustic project(s) associated with the receivers from which the
  detections were obtained.

It is recommended to cite these when using the data, see the [ETN
Citation
Guidelines](https://europeantrackingnetwork.org/en/4-data-policy-permissions-citation-guidelines-and-data-use)
for details.

## Usage

``` r
get_bibliography(detections)
```

## Arguments

- detections:

  A data frame containing at least the columns `animal_project_code` and
  `acoustic_project_code`. Typically a data frame returned by
  [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md).

## Value

A data frame with three columns (`item`, `type`, and `citation`)
containing the references.

## See also

Other access functions:
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
if (FALSE) { # interactive() && etn:::credentials_are_set()
# Create a bibliography from queried detections
get_acoustic_detections(scientific_name = "Mola mola") |>
  get_bibliography()

# Or obtain the bibliography from a Data Package
read_resource(example_dataset(), "bibliography")
}
```
