# detections_view

# RODBCext
# https://cran.r-project.org/web/packages/RODBCext/vignettes/Parameterized_SQL_queries.html

#   if("All" %in% projectlist) projectlist=NULL
#   if("All" %in% tagprojectlist) tagprojectlist=NULL


get_detections <- function(connection, network_project = NULL,
                           animal_project = NULL, start_date = NULL,
                           end_date = NULL, station = NULL,
                           tags = NULL, limit = 100) {
  check_connection(connection)

  # check the network project inputs
  valid_network_projects <- get_projects(connection, project_type = "network") %>%
    pull(projectcode)
  check_null_or_value(network_project, valid_network_projects, "network_project")
  if (is.null(network_project)) {
    network_project = valid_network_projects
  }

  # check the animal project inputs
  valid_animal_projects <- get_projects(connection, project_type = "animal") %>%
    pull(projectcode)
  check_null_or_value(animal_project,  valid_animal_projects, "animal_project")
  if (is.null(animal_project)) {
    animal_project = valid_animal_projects
  }

  # check the start- and enddate inputs
  if (is.null(start_date)) {
    # use an arbitrary early date for this project
    start_date <- check_datetime("1970", "start_date")
  } else {
    start_date <- check_datetime(start_date, "start_date")
  }

  if (is.null(end_date)) {
    # use today
    end_date <- as.character(Sys.Date())
  } else {
    end_date <- check_datetime(end_date, "end_date")
  }

  # check the station inputs

  # check the tags inputs

  # check the limit input
  assert_that(is.number(limit))

  detections_query <- glue_sql(
    "SELECT * FROM vliz.detections_view
    WHERE network_project_code IN ({network_project*})
      AND animal_project_code IN ({animal_project*})
      AND datetime > {start_date}
      AND datetime < {end_date}
    LIMIT {nrows}",
    network_project = network_project,
    animal_project = animal_project,
    start_date = start_date,
    end_date = end_date,
    nrows = as.character(limit),
    .con = connection
  )
  detections <- dbGetQuery(connection, detections_query)
  detections

}

