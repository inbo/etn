#' Count acoustic detections
#' @inheritParams get_acoustic_detections_page
#'
#' @export
#'
count_acoustic_detections2 <- function(credentials = list(username = Sys.getenv("ETN_USER"),
                                                         password = Sys.getenv("ETN_PWD")),
                                      start_date = NULL,
                                      end_date = NULL,
                                      tag_serial_number = NULL,
                                      acoustic_tag_id = NULL,
                                      animal_project_code = NULL,
                                      scientific_name = NULL,
                                      acoustic_project_code = NULL,
                                      deployment_id = NULL,
                                      receiver_id = NULL,
                                      station_name = NULL) {
  # Check if credentials object has right shape
  check_credentials(credentials)

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check if we can make a connection
  check_connection(connection)

  # Argument checks and conversion to query elements -----
  # Check start_date
  if (is.null(start_date)) {
    start_date_query <- "True"
  } else {
    start_date <- check_date_time(start_date, "start_date")
    start_date_query <- glue::glue_sql("det.datetime >= {start_date}", .con = connection)
  }

  # Check end_date
  if (is.null(end_date)) {
    end_date_query <- "True"
  } else {
    end_date <- check_date_time(end_date, "end_date")
    end_date_query <- glue::glue_sql("det.datetime < {end_date}", .con = connection)
  }

  # Check tag_serial_number
  if (is.null(tag_serial_number)) {
    tag_serial_number_query <- "True"
  } else {
    tag_serial_number <- check_value(tag_serial_number,
                                     list_tag_serial_numbers(credentials),
                                     "tag_serial_number")
    tag_serial_number_query <- glue::glue_sql("det.tag_serial_number IN ({tag_serial_number*})", .con = connection)
  }

  # Check acoustic_tag_id
  if (is.null(acoustic_tag_id)) {
    acoustic_tag_id_query <- "True"
  } else {
    acoustic_tag_id <- check_value(acoustic_tag_id,
                                   list_acoustic_tag_ids(credentials),
                                   "acoustic_tag_id")
    acoustic_tag_id_query <- glue::glue_sql("det.transmitter IN ({acoustic_tag_id*})", .con = connection)
  }

  # Check animal_project_code
  if (is.null(animal_project_code)) {
    animal_project_code_query <- "True"
  } else {
    animal_project_code <- check_value(
      animal_project_code,
      list_animal_project_codes(credentials),
      "animal_project_code",
      lowercase = TRUE
    )
    animal_project_code_query <- glue::glue_sql("LOWER(animal_project_code) IN ({animal_project_code*})",
                                                .con = connection)
  }

  # Check scientific_name
  if (is.null(scientific_name)) {
    scientific_name_query <- "True"
  } else {
    scientific_name <- check_value(scientific_name,
                                   list_scientific_names(credentials),
                                   "scientific_name")
    scientific_name_query <- glue::glue_sql("animal_scientific_name IN ({scientific_name*})", .con = connection)
  }

  # Check acoustic_project_code
  if (is.null(acoustic_project_code)) {
    acoustic_project_code_query <- "True"
  } else {
    acoustic_project_code <- check_value(
      acoustic_project_code,
      list_acoustic_project_codes(credentials),
      "acoustic_project_code",
      lowercase = TRUE
    )
    acoustic_project_code_query <- glue::glue_sql("LOWER(network_project_code) IN ({acoustic_project_code*})",
                                                  .con = connection)
  }

  # Check deployment id
  if (is.null(deployment_id)) {
    deployment_id_query <- "True"
  } else {
    deployment_id <- check_value(deployment_id,
                                 list_deployment_ids(credentials),
                                 "deployment_id")
    deployment_id_query <- glue::glue_sql("det.deployment_fk IN ({deployment_id*})", .con = connection)
  }

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    receiver_id <- check_value(receiver_id,
                               list_receiver_ids(credentials),
                               "receiver_id")
    receiver_id_query <- glue::glue_sql("det.receiver IN ({receiver_id*})", .con = connection)
  }

  # Check station_name
  if (is.null(station_name)) {
    station_name_query <- "True"
  } else {
    station_name <- check_value(station_name,
                                list_station_names(credentials),
                                "station_name")
    station_name_query <- glue::glue_sql("deployment_station_name IN ({station_name*})", .con = connection)
  }

  # If we have animal information, use acoustic.detections_animal view,
  # otherwise use the acoustic.detections_network view.

  if (!is.null(animal_project_code) || !is.null(scientific_name)) {
    # If either animal_project_code or scientific_name are provided, use the
    # animal view
    view_to_query <- "acoustic.detections_animal"
  } else {
    view_to_query <- "acoustic.detections_network"
  }

  ## Build query -----
  query <- glue::glue_sql(
    "SELECT",
    ifelse(count, " COUNT(*)", " *"),
    " FROM ",
    view_to_query,
    " AS det",
    "
    WHERE
      {start_date_query}
      AND {end_date_query}
      AND {tag_serial_number_query}
      AND {acoustic_tag_id_query}
      AND {animal_project_code_query}
      AND {scientific_name_query}
      AND {acoustic_project_code_query}
      AND {deployment_id_query}
      AND {receiver_id_query}
      AND {station_name_query}
      AND det.detection_id_pk > {next_id_pk}
    {limit_query}
    ",
    .con = connection,
    page_size_query = ifelse(count, "ALL", page_size)
  )

  # Execute query -----
  returned_page <- DBI::dbGetQuery(connection, query)

  # Close connection -----
  DBI::dbDisconnect(connection)

  # Return query result (mapped or not)
  dplyr::as_tibble(returned_page)
}
