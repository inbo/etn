# Download acoustic data package

Download all acoustic data related to an **animal project** as a data
package that can be deposited in a research data repository. Includes
option to filter on scientific names.

## Usage

``` r
download_acoustic_dataset(
  connection,
  animal_project_code,
  scientific_name = NULL,
  directory = animal_project_code
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- animal_project_code:

  Character. Animal project you want to download data for. Required.

- scientific_name:

  Character (vector). One or more scientific names. Defaults to no all
  (all scientific names, include "Sync tag", etc.).

- directory:

  Character. Relative path to local download directory. Defaults to
  creating a directory named after animal project code. Existing files
  of the same name will be overwritten.

## Value

CSV and JSON files written to disk.

## Details

The data are downloaded as a **[Frictionless Data
Package](https://specs.frictionlessdata.io/data-package/)** containing:

|                    |                                                                                                                                                                                                                                                                                                              |
|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| file               | description                                                                                                                                                                                                                                                                                                  |
| `animals.csv`      | Animals related to an `animal_project_code`, optionally filtered on `scientific_name`(s), as returned by [`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md).                                                                                                                             |
| `tags.csv`         | Tags associated with the selected animals, as returned by [`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md).                                                                                                                                                                                  |
| `detections.csv`   | Acoustic detections for the selected animals, as returned by [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md).                                                                                                                                                 |
| `deployments.csv`  | Acoustic deployments for the `acoustic_project_code`(s) found in detections, as returned by [`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md). This allows users to see when receivers were deployed, even if these did not detect the selected animals.      |
| `receivers.csv`    | Acoustic receivers for the selected deployments, as returned by [`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md).                                                                                                                                                |
| `datapackage.json` | A [Frictionless Table Schema](https://specs.frictionlessdata.io/table-schema/) metadata file describing the fields and relations of the above csv files. This file is copied from [here](https://github.com/inbo/etn/blob/master/inst/assets/datapackage.json) and can be used to validate the data package. |

The function will report the number of records per csv file, as well as
the included scientific names and acoustic projects. Warnings will be
raised for:

- Animals with multiple tags

- Tags associated with multiple animals

- Deployments without acoustic project: these deployments will not be
  listed in `deployments.csv` and will therefore raise a foreign key
  validation error.

- Duplicate detections: detections with the duplicate `detection_id`.
  These are removed by the function in `detections.csv`.

**Important**: The data are downloaded *as is* from the database, i.e.
no quality or consistency checks are performed by this function. We
therefore recommend to verify the data before publication. A consistency
check can be performed by validation tools of the Frictionless
Framework, e.g. `frictionless validate datapackage.json` on the command
line using
[frictionless-py](https://github.com/frictionlessdata/frictionless-py).

## Examples

``` r
if (FALSE) { # etn:::credentials_are_set() & interactive()
# Download data for the 2012_leopoldkanaal animal project (all scientific names)
download_acoustic_dataset(animal_project_code = "2012_leopoldkanaal",
                         directory = tempdir())
#> Downloading data to directory `2012_leopoldkanaal`:
#> * (1/6): downloading animals.csv
#> * (2/6): downloading tags.csv
#> * (3/6): downloading detections.csv
#> * (4/6): downloading deployments.csv
#> * (5/6): downloading receivers.csv
#> * (6/6): adding datapackage.json as file metadata
#>
#> Summary statistics for dataset `2012_leopoldkanaal`:
#> * number of animals:           104
#> * number of tags:              103
#> * number of detections:        2215243
#> * number of deployments:       1968
#> * number of receivers:         454
#> * first date of detection:     2012-07-04
#> * last date of detection:      2021-09-02
#> * included scientific names:   Anguilla anguilla
#> * included acoustic projects:  albert, Apelafico, bpns, JJ_Belwind, leopold, MOBEIA, pc4c, SPAWNSEIS, ws2, zeeschelde
#>
#> Warning message:
#> In download_acoustic_dataset(animal_project_code = "2012_leopoldkanaal") :
#> Found tags associated with multiple animals: 1145373
}
```
