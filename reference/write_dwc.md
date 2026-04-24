# Transform a Data Package with ETN data to a Darwin Core Archive

Transforms a Data Package with European Tracking Network (ETN) data to a
[Darwin Core Archive](https://dwc.tdwg.org/text/).

## Usage

``` r
write_dwc(
  package,
  directory,
  dataset_id = package$id,
  dataset_name = NULL,
  license = c("CC-BY-4.0", "CC0-1.0"),
  rights_holder = NULL
)
```

## Arguments

- package:

  A Data Package with ETN data, as returned by
  [`read_package()`](https://inbo.github.io/etn/reference/read_package.md)
  or
  [`get_package()`](https://inbo.github.io/etn/reference/get_package.md).
  It is expected to contain the resources `animals`, `tags`,
  `detections` and `deployments`.

- directory:

  Path to local directory to write files to.

- dataset_id:

  Identifier for the dataset.

- dataset_name:

  Title of the dataset.

- license:

  License of the dataset.

- rights_holder:

  Acronym of the organization owning or managing the rights over the
  data.

## Value

CSV and `meta.xml` files written to disk. And invisibly, a list of data
frames with the transformed data.

## Details

The resulting files can be uploaded to an
[IPT](https://www.gbif.org/ipt) for publication to GBIF and/or OBIS. A
corresponding `eml.xml` metadata file is not created.

## Transformation details

This function **follows recommendations** discussed and created by Peter
Desmet, Jonas Mortelmans, Jonathan Pye, John Wieczorek and others and
transforms data to:

- An [Occurrence
  core](https://rs.gbif.org/core/dwc_occurrence_2022-02-02.xml).

- An [Extended Measurement Or Facts
  extension](https://rs.gbif.org/extension/obis/extended_measurement_or_fact_2023-08-28.xml)

- A `meta.xml` file.

Key features of the Darwin Core transformation:

- Deployments (animal+tag associations) are parent events, with capture,
  surgery, release, recapture (human observations) and acoustic
  detections (machine observations) as child events. No information
  about the parent event is provided other than its ID, meaning that
  data can be expressed in an Occurrence Core with one row per
  observation and `parentEventID` shared by all occurrences in a
  deployment.

- The release event often contains metadata about the animal (sex, life
  stage, comments) and deployment as a whole. Sex, life stage and weight
  are (additionally) provided in an Extended Measurement Or Facts
  extension, where values are mapped to a controlled vocabulary
  recommended by [OBIS](https://obis.org/).

- Acoustic detections are downsampled to the **first detection per
  hour**, to reduce the size of high-frequency data. The
  `coordinateUncertaintyInMeters` is set to 1000 m to account for
  imprecise receiver location and acoustic detection range. Duplicate
  detections (same animal, tag and timestamp) are excluded. It is
  possible for a deployment to contain no detections, e.g. if the tag
  malfunctioned right after deployment.

- Parameters or metadata are used to set the following record-level
  terms:

  - `dwc:datasetID`: `dataset_id`, defaulting to `package$id`.

  - `dwc:datasetName`: `dataset_name`.

  - `dcterms:license`: `license`.

  - `dcterms:rightsHolder`: `rights_holder`.

## Examples

``` r
package <- example_dataset()
write_dwc(
  package,
  directory = "my_directory",
  dataset_name = paste(
    "2014_DEMER - Acoustic telemetry data for four fish species in the",
    "Demer river (Belgium)"
  ),
  license = "CC0-1.0",
  rights_holder = "INBO"
)
#> 
#> ── Reading data ──
#> 
#> ── Transforming data to Darwin Core ──
#> 
#> ── Writing files ──
#> 
#> • my_directory/occurrence.csv
#> • my_directory/meta.xml
#> • my_directory/emof.csv

# Clean up (don't do this if you want to keep your files)
unlink("my_directory", recursive = TRUE)
```
