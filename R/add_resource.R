#' Add ETN data to a Data Package
#'
#' Adds ETN data (`animals`, `tags`, `detections`, `deployments` or `receivers`)
#' as a Data Resource to a Data Package.
#' The function extends [frictionless::add_resource()] by adding the following
#' to the Table Schema of the resource:
#' - The definition, type, unit and example for each field, from
#'   `inst/extdata/field_definitions.tsv`.
#' - The primary key of the resource and foreign keys between resources.
#'
#' @inheritParams frictionless::add_resource
#' @param data Data frame to attach.
#' @return `package` with one additional resource.
#' @family frictionless functions
#' @noRd
add_resource <- function(package, resource_name, data) {
  # Check resource names
  allowed_names <- c("animals", "deployments", "detections", "receivers", "tags")
  if (!resource_name %in% allowed_names) {
    cli::cli_abort(
      c(
        "{.arg resource_name} must be a recognized ETN data type.",
        "x" = "{.val {resource_name}} is not.",
        "i" = "Allowed: {.val {allowed_names}}."
      ),
      class = "etn_error_resource_name_invalid"
    )
  }

  # Create schema
  schema <- frictionless::create_schema(data)

  # Add field definition, type, unit and example to schema
  path <- system.file("extdata", "field_definitions.tsv", package = "etn")
  field_definitions <-
    readr::read_tsv(path, show_col_types = FALSE) |>
    dplyr::filter(table == resource_name)

  fields <- purrr::map(schema$fields, function(field) {
    field_definition <-
      dplyr::filter(field_definitions, .data$name == field$name) |>
      dplyr::slice_head(n = 1) |> # Choose first row in case there are more
      as.list()

    field_output <- list(
      name = field$name, # Field name from schema
      description = purrr::pluck(field_definition, "definition"),
      type = purrr::pluck(field_definition, "type"), # Overwrite guessed type
      format = "default", # Needed for example validation of datetime
      unit = purrr::pluck(field_definition, "unit"),
      example = purrr::pluck(field_definition, "example")
    )
    purrr::discard(field_output, function(x) is.na(x)) # Remove NA properties
  })
  schema$fields <- fields

  # Add keys
  if (resource_name == "animals") {
    schema$primaryKey <- "animal_id"
    schema$foreignKeys <- list(
      list(
        fields = c("tag_serial_number"),
        reference = list(
          resource = "tags",
          fields = c("tag_serial_number")
        )
      )
    )
  }
  if (resource_name == "tags") {
    schema$primaryKey <- "tag_id"
  }
  if (resource_name == "detections") {
    schema$primaryKey <- "detection_id"
    schema$foreignKeys <- list(
      list(
        fields = c("tag_serial_number"),
        reference = list(
          resource = "tags",
          fields = c("tag_serial_number")
        )
      ),
      list(
        fields = c("animal_id"),
        reference = list(
          resource = "animals",
          fields = c("animal_id")
        )
      ),
      list(
        fields = c("receiver_id"),
        reference = list(
          resource = "receivers",
          fields = c("receiver_id")
        )
      ),
      list(
        fields = c("deployment_id"),
        reference = list(
          resource = "deployments",
          fields = c("deployment_id")
        )
      )
    )
  }
  if (resource_name == "deployments") {
    schema$primaryKey <- "deployment_id"
    schema$foreignKeys <- list(
      list(
        fields = c("receiver_id"),
        reference = list(
          resource = "receivers",
          fields = c("receiver_id")
        )
      )
    )
  }
  if (resource_name == "receivers") {
    schema$primaryKey <- "receiver_id"
  }

  # Add resource to package
  frictionless::add_resource(
    package = package,
    resource_name = resource_name,
    data = data,
    schema = schema
  )
}
