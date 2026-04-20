#' Add ETN data to a Frictionless Data Package
#'
#' Adds ETN data (`animals`, `deployments`, `detections`, `receivers`, `tags`)
#' as a  Data Resource to a Frictionless Data Package.
#' The function extends [frictionless::add_resource()].
#'
#' @inheritParams frictionless::read_resource
#' @param data Data frame to attach
#' @return Provided `package` with one additional resource.
#' @family frictionless functions
#' @export
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
        fields = c("receiver_id"),
        reference = list(
          resource = "receivers",
          fields = c("receiver_id")
        )
      ),
      list(
        fields = c("acoustic_tag_id"),
        reference = list(
          resource = "tags",
          fields = c("acoustic_tag_id")
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
