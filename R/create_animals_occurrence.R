#' Create Darwin Core Occurrence from animals data
#'
#' @param animals A data frame derived from an `animals` resource.
#' @return A data frame with Darwin Core occurrences.
#' @family dwc functions
#' @noRd
create_animals_occurrence <- function(animals, tags) {
  # Expand data with non-required columns used in Darwin Core transformation
  animals_cols <- c(
    "capture_date_time", "capture_location", "capture_latitude",
    "capture_longitude", "surgery_date_time", "surgery_location",
    "surgery_latitude", "surgery_longitude", "release_date_time",
    "release_location", "release_latitude", "release_longitude",
    "recapture_date_time", "animal_nickname", "sex", "life_stage",
    "capture_method", "tagging_type", "wild_or_hatchery"
  )
  animals <- expand_cols(animals, animals_cols)
  tags_cols <- c("manufacturer", "model")
  tags <- expand_cols(tags, tags_cols)

  # 'animals' contains multiple events (capture, release, surgery, recapture) as
  # columns. Transpose events to rows and exclude those without date information.
  captures <-
    animals |>
    dplyr::mutate(
      animal_id = .data$animal_id,
      protocol = "capture",
      date = .data$capture_date_time,
      locality = .data$capture_location,
      latitude = as.numeric(.data$capture_latitude),
      longitude = as.numeric(.data$capture_longitude)
    )

  surgeries <-
    animals |>
    dplyr::mutate(
      animal_id = .data$animal_id,
      protocol = "surgery",
      date = .data$surgery_date_time,
      locality = as.character(.data$surgery_location),
      latitude = as.numeric(.data$surgery_latitude),
      longitude = as.numeric(.data$surgery_longitude)
    )

  releases <-
    animals |>
    dplyr::mutate(
      animal_id = .data$animal_id,
      protocol = "release",
      date = .data$release_date_time,
      locality = .data$release_location,
      latitude = as.numeric(.data$release_latitude),
      longitude = as.numeric(.data$release_longitude)
    )

  recaptures <-
    animals |>
    dplyr::mutate(
      animal_id = .data$animal_id,
      protocol = "recapture",
      date = .data$recapture_date_time,
      locality = NA_character_,
      latitude = NA_real_,
      longitude = NA_real_
    )

  events <-
    dplyr::bind_rows(captures, surgeries, releases, recaptures) |>
    dplyr::filter(!is.na(.data$date)) |>
    dplyr::arrange(.data$animal_id, .data$date) |>
    dplyr::select(
      "animal_id", "protocol", "date", "locality", "latitude",
      "longitude", "scientific_name", "aphia_id", "animal_nickname", "sex",
      "life_stage", "tag_serial_number", "capture_method",
      "tagging_type", "wild_or_hatchery"
    ) |>
    dplyr::left_join(
      tags,
      by = dplyr::join_by("tag_serial_number")
    )

  animals_occurrence <-
    events |>
    dplyr::mutate(
      .keep = "none",
      # RECORD-LEVEL
      basisOfRecord = "HumanObservation",
      dataGeneralizations = NA_character_,
      # OCCURRENCE
      occurrenceID = paste(
        .data$animal_id, .data$tag_serial_number, .data$protocol, sep = "_"
      ),
      sex = dplyr::recode_values(
        tolower(.data$sex),
        c("male", "m") ~ "male",
        c("female", "f") ~ "female",
        c("hermaphrodite") ~ "hermaphrodite",
        c("unknown", "u") ~ "unknown",
        default = "unknown"
      ),
      lifeStage = dplyr::if_else(
        # Only at release, life stage can change over time
        .data$protocol == "release",
        dplyr::recode_values(
          .data$life_stage,
          # Follows http://vocab.nerc.ac.uk/collection/S11/current/
          # See https://github.com/inbo/etn/issues/262
          c("juvenile", "i", "fii", "fiii") ~ "juvenile",
          c("sub-adult", "fiv", "fv", "mii", "silver") ~ "sub-adult",
          c("adult", "mature") ~ "adult",
          c("immature", "imature") ~ "immature",
          c("smolt") ~ "smolt"
          # Exclude unknown, and other values
        ),
        NA_character_
      ),
      occurrenceStatus = "present",
      # ORGANISM
      organismID = .data$animal_id,
      organismName = .data$animal_nickname,
      # EVENT
      eventID = paste(
        .data$animal_id, .data$tag_serial_number, .data$protocol, sep = "_"
      ),
      parentEventID = paste(.data$animal_id, .data$tag_serial_number, sep = "_"),
      eventDate = format(.data$date, format = "%Y-%m-%dT%H:%M:%SZ"),
      samplingProtocol = .data$protocol,
      eventRemarks = dplyr::case_when(
        .data$protocol == "capture" & !is.na(.data$capture_method) ~
          paste("Caught using", trimws(tolower(.data$capture_method))),
        .data$protocol == "release" ~
          paste0(
            .data$manufacturer, " ", .data$model, " tag ",
            dplyr::case_when(
              .data$tagging_type == "internal" ~ "implanted in ",
              .data$tagging_type == "external" ~ "attached to ",
              # Includes `Acoustic and pit`
              .default = "implanted in or attached to "
            ),
            dplyr::case_when(
              .data$wild_or_hatchery %in% c("wild", "w") ~ "free-ranging animal",
              .data$wild_or_hatchery %in% c("hatchery", "h") ~ "hatched animal",
              .default = "likely free-ranging animal"
            )
          ),
        .default = NA_character_
      ),
      # LOCATION
      locationID = NA_character_,
      locality = .data$locality,
      decimalLatitude = .data$latitude,
      decimalLongitude = .data$longitude,
      geodeticDatum = dplyr::if_else(
        !is.na(.data$latitude),
        "EPSG:4326",
        NA_character_
      ),
      coordinateUncertaintyInMeters = dplyr::if_else(
        !is.na(.data$latitude),
        # Assume coordinate precision of 0.001 degree (157m) and recording
        # by GPS (30m)
        187,
        NA_real_
      ),
      # IDENTIFICATION
      identificationVerificationStatus = "verified by expert",
      # TAXON
      scientificNameID =
        paste0("urn:lsid:marinespecies.org:taxname:", .data$aphia_id),
      scientificName = .data$scientific_name,
      kingdom = "Animalia",
    ) |>
    dplyr::select(dplyr::all_of(c(
      "basisOfRecord", "dataGeneralizations", "occurrenceID", "sex",
      "lifeStage", "occurrenceStatus", "organismID", "organismName", "eventID",
      "parentEventID", "eventDate", "samplingProtocol", "eventRemarks",
      "locationID", "locality", "decimalLatitude", "decimalLongitude",
      "geodeticDatum", "coordinateUncertaintyInMeters",
      "identificationVerificationStatus", "scientificNameID",
      "scientificName", "kingdom"
    ))) |>
    dplyr::arrange(.data$parentEventID, .data$eventDate, .data$samplingProtocol)

  return(animals_occurrence)
}
