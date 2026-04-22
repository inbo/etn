#' Create Extended Measurement Or Facts from `animals` resource
#'
#' Pulls the **sex**, **life stage** and ** weight** information from an
#' `animals` resource and maps these values to a controlled vocabulary
#' recommended by [OBIS](https://obis.org/). All measurement or facts are linked
#' to the release occurrence of an animal.
#'
#' @param animals Data frame derived from an `animals` resource.
#' @return Data frame with [Extended Measurement Or Facts](
#'   https://rs.gbif.org/extension/obis/extended_measurement_or_fact_2023-08-28.xml).
#' @family dwc functions
#' @noRd
create_emof <- function(animals) {
  # Expand data with non-required columns used in emof transformation
  animals_cols <- c(
    "release_date_time", "animal_nickname", "sex", "life_stage", "weight"
  )

  # Create release occurrenceID & standardize sex/life stage values
  animals <-
    expand_cols(animals, animals_cols) |>
    dplyr::filter(!is.na(.data$release_date_time)) |>
    dplyr::select(
      "animal_id", "sex", "life_stage", "weight", "tag_serial_number"
    ) |>
    dplyr::mutate(
      occurrenceID = paste(
        .data$animal_id, .data$tag_serial_number, "release", sep = "_"
      ),
      sex = dplyr::recode_values(
        tolower(.data$sex),
        c("female", "f") ~ "female",
        c("male", "m") ~ "male",
        c("hermaphrodite") ~ "hermaphrodite",
        c("unknown", "u") ~ "unknown",
        default = "unknown"
      ),
      lifeStage = dplyr::recode_values(
        .data$life_stage,
        # Follows http://vocab.nerc.ac.uk/collection/S11/current/
        # See https://github.com/inbo/etn/issues/262
        c("adult", "mature") ~ "adult",
        c("sub-adult", "fiv", "fv", "mii", "silver") ~ "sub-adult",
        c("juvenile", "i", "fii", "fiii") ~ "juvenile",
        c("immature", "imature") ~ "immature",
        c("smolt") ~ "smolt"
        # Exclude unknown, and other values
      )
    ) |>
    dplyr::select(dplyr::all_of(c(
      "occurrenceID", "sex", "lifeStage", "weight"
    )))

  sex <-
    animals |>
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
    animals |>
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

  weight <-
    animals |>
    dplyr::mutate(
      .keep = "none",
      occurrenceID = .data$occurrenceID,
      measurementType = "weight",
      measurementTypeID = "https://vocab.nerc.ac.uk/collection/P01/current/SPWGXX01/",
      measurementValue = as.character(.data$weight),
      measurementValueID = NA_character_,
      measurementUnit = "g",
      measurementUnitID = "http://vocab.nerc.ac.uk/collection/P06/current/UGRM/"
    )

  emof <-
    dplyr::bind_rows(sex, lifestage, weight) |>
    dplyr::arrange(.data$occurrenceID)

  # Remove the measurementType if all values of that type are NA in animals
  if (all(is.na(animals$sex))) {
    emof <- dplyr::filter(emof, .data$measurementType != "sex")
  }
  if (all(is.na(animals$lifeStage))) {
    emof <- dplyr::filter(emof, .data$measurementType != "life stage")
  }
  if (all(is.na(animals$weight))) {
    emof <- dplyr::filter(emof, .data$measurementType != "weight")
  }

  return(emof)
}
