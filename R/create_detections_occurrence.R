#' Create Darwin Core Occurrence from detections data
#'
#' @param detections A data frame derived from a `detections` resource.
#' @return A data frame with Darwin Core occurrences
#' @family dwc functions
#' @noRd
create_detections_occurrence <- function(detections, animals,
                                         deployments) {
  # Expand data with non-required columns used in Darwin Core transformation
  detections_cols <- c("qc_flag", "station_name")
  detections <- expand_cols(detections, detections_cols)

  animals_cols <- c("sex", "animal_nickname", "animal_nickname")
  animals <- expand_cols(animals, animals_cols)
  animals_subset <-
    animals |>
    dplyr::select("animal_id", "sex", "animal_nickname", "aphia_id")

  deployment_cols <- c("station_description")
  deployments <- expand_cols(deployments, deployment_cols)
  deployments_subset <-
    deployments |>
    dplyr::select("deployment_id", "station_description")

  # Transform data
  occurrence <-
    detections |>
    # Remove duplicates by removing records with qc_flag = FALSE.
    # qc_flag is either FALSE or NA.
    dplyr::filter(!isFALSE(.data$qc_flag)) |>
    dplyr::mutate(
      time_per_hour = strftime(.data$date_time, "%y-%m-%d %H %Z", tz = "UTC")
    ) |>
    # Group by animal+tag+date+hour combination
    dplyr::group_by(
      .data$animal_id,
      .data$tag_serial_number,
      .data$time_per_hour
    ) |>
    dplyr::arrange(.data$date_time) |>
    dplyr::mutate(subsample_count = dplyr::n()) |>
    # Take first record/timestamp within group
    dplyr::filter(dplyr::row_number() == 1) |>
    dplyr::ungroup() |>
    dplyr::left_join(animals_subset, by = "animal_id") |>
    dplyr::left_join(deployments_subset, by = "deployment_id") |>
    dplyr::mutate(
      .keep = "none",
      # RECORD-LEVEL
      basisOfRecord = "MachineObservation",
      dataGeneralizations = paste(
        "subsampled by hour: first of", .data$subsample_count, "record(s)"
      ),
      # OCCURRENCE
      occurrenceID = as.character(.data$detection_id),
      sex = dplyr::recode_values(
        tolower(.data$sex),
        c("male", "m") ~ "male",
        c("female", "f") ~ "female",
        "hermaphrodite" ~ "hermaphrodite",
        c("unknown", "u") ~ "unknown",
      ),
      # Value at start of deployment might not apply to all records
      lifeStage = NA_character_,
      reproductiveCondition = NA_character_,
      occurrenceStatus = "present",
      # ORGANISM
      organismID = .data$animal_id,
      organismName = .data$animal_nickname,
      # EVENT
      eventID = as.character(.data$detection_id),
      parentEventID = paste(
        .data$animal_id,
        .data$tag_serial_number,
        sep = "_"
      ),
      eventDate = format(.data$date_time, format = "%Y-%m-%dT%H:%M:%SZ"),
      samplingProtocol = "acoustic telemetry",
      eventRemarks = paste("detected on receiver", .data$receiver_id),
      # LOCATION
      locationID = .data$station_name,
      locality = .data$station_description,
      decimalLatitude = as.numeric(.data$deploy_latitude),
      decimalLongitude = as.numeric(.data$deploy_longitude),
      geodeticDatum = dplyr::if_else(
        !is.na(.data$deploy_latitude),
        "EPSG:4326",
        NA_character_
      ),
      coordinateUncertaintyInMeters = dplyr::if_else(
        !is.na(.data$deploy_latitude),
        # Assume coordinate precision of 0.001 degree (157m), recording by GPS
        # (30m) and detection range of around 800m ≈ 1000m.
        # See https://github.com/inbo/etn/issues/256#issuecomment-1332224935.
        1000,
        NA_real_
      ),
      # TAXON
      scientificNameID =
        paste0("urn:lsid:marinespecies.org:taxname:", .data$aphia_id),
      scientificName = .data$scientific_name,
      kingdom = "Animalia"
    ) |>
    dplyr::select(
      "basisOfRecord", "dataGeneralizations", "occurrenceID", "sex",
      "lifeStage", "occurrenceStatus", "organismID", "organismName", "eventID",
      "parentEventID", "eventDate", "samplingProtocol", "eventRemarks",
      "locationID", "locality", "decimalLatitude", "decimalLongitude",
      "geodeticDatum", "coordinateUncertaintyInMeters", "scientificNameID",
      "scientificName", "kingdom"
    ) |>
    dplyr::arrange(.data$parentEventID, .data$eventDate, .data$samplingProtocol)

  return(occurrence)
}
