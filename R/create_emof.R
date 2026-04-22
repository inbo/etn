#' Create Extended Measurements Or Facts from Darwin Core Occurrence data
#'
#' Pulls the **sex** and **life stage** information from the Darwin Core
#' Occurrence data created with `create_animals_occurrence()` and maps these
#' values to a controlled vocabulary recommended by [OBIS](https://obis.org/).
#'
#' @param animals_occurrence Data frame with Darwin Core occurrences derived
#' from `animals` resource, as returned by `create_animals_occurrence()`.
#' @return Data frame with [Extended Measurement Or Facts](
#'   https://rs.gbif.org/extension/obis/extended_measurement_or_fact_2023-08-28.xml).
#' @family transformation functions
#' @noRd
create_emof <- function(animals_occurrence) {
  sex <-
    animals_occurrence |>
    dplyr::mutate(
      .keep = "none",
      occurrenceID = .data$occurrenceID,
      measurementType = "sex",
      measurementTypeID =
        "http://vocab.nerc.ac.uk/collection/P01/current/ENTSEX01/",
      measurementValue = .data$sex, # Value as is
      measurementValueID = dplyr::recode_values(
        .data$sex,
        "female" ~ "http://vocab.nerc.ac.uk/collection/S10/current/S102/",
        "male" ~ "https://vocab.nerc.ac.uk/collection/S10/current/S103/",
        "unknown" ~ "https://vocab.nerc.ac.uk/collection/S10/current/S105/", # indeterminate
        NA ~ "https://vocab.nerc.ac.uk/collection/S10/current/S104/", # not specified
        default = NA_character_ # Don't map other values
      ),
      measurementUnit = NA_character_,
      measurementUnitID = "http://vocab.nerc.ac.uk/collection/P06/current/XXXX/"
    )

  lifestage <-
    animals_occurrence |>
    dplyr::mutate(
      .keep = "none",
      occurrenceID = .data$occurrenceID,
      measurementType = "life stage",
      measurementTypeID =
        "http://vocab.nerc.ac.uk/collection/P01/current/LSTAGE01/",
      measurementValue = .data$lifeStage, # Value as is
      measurementValueID = dplyr::recode_values(
        .data$lifeStage,
        "adult" ~ "http://vocab.nerc.ac.uk/collection/S11/current/S1116/",
        "subadult" ~ "https://vocab.nerc.ac.uk/collection/S11/current/S120/", # sub-adult
        "juvenile" ~ "https://vocab.nerc.ac.uk/collection/S11/current/S1127/",
        "unknown" ~ "http://vocab.nerc.ac.uk/collection/S11/current/S1152/", # indeterminate
        NA ~ "http://vocab.nerc.ac.uk/collection/S11/current/S1131/", # not specified
        default = NA_character_ # Don't map other values
      ),
      measurementUnit = NA_character_,
      measurementUnitID = "http://vocab.nerc.ac.uk/collection/P06/current/XXXX/"
    )

  emof <-
    dplyr::bind_rows(sex, lifestage) |>
    dplyr::filter(!endsWith(.data$occurrenceID, "_capture")) |>
    dplyr::arrange(.data$occurrenceID)

  # Remove the measurementType if all values of that type are NA in animals_occurrence
  if (all(is.na(animals_occurrence$sex))) {
    emof <- dplyr::filter(emof, .data$measurementType != "sex")
  }
  if (all(is.na(animals_occurrence$lifeStage))) {
    emof <- dplyr::filter(emof, .data$measurementType != "life stage")
  }

  return(emof)
}
