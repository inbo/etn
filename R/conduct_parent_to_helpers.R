#' Conductor Helper: point the way to API or SQL helper
#'
#' Helper that conducts it's parent function to either use a helper to query the
#' api, or a helper to query a local database connection using SQL.
#'
#' This function will change the behaviour of etn based on the  value of the
#' `api` argument of it's functions. When `api == TRUE` it'll use the
#' function_identity, the name of the parent function that calls this helper to
#' create the api call via `forward_to_api()`. If `api == FALSE` it'll get the
#' correct function from the namespace of `etnservice` so it can query a local
#' database connection. The package was constructed this way to ensure
#' etnservice which creates the API via OpenCPU, and local queries to etn always
#' result in the same output as the api. This also ensures the actual queries
#' only need to be maintained in a single place. See examples to see in
#' practise.
#'
#' @param api Logical, Should the API be used?
#' @param ignored_arguments Character vector of arguments not to pass to the API
#'   or SQL helper
#' @param ... options on how to fetch the response. Forwarded to
#'   `forward_to_api()`
#'
#' @return parsed R object as resulting from the API
#'
#' @family helper functions
#' @noRd
conduct_parent_to_helpers <- function(protocol = c("opencpu", "localdb"),
                                      ignored_arguments = NULL,
                                      ...) {
  # Check arguments
  protocol <- rlang::arg_match(protocol)
  if (!(is.character(ignored_arguments) || is.null(ignored_arguments))) {
    cli::cli_abort("{ignored_arguments} should be a character vector or NULL.")
  }

  # Lock in the name of the parent function
  function_identity <-
    get_parent_fn_name(depth = 2)

  # Get the argument values from the parent function, drop arguments set to NULL
  arguments_to_pass <-
    return_parent_arguments(depth = 2)[
      !names(return_parent_arguments(depth = 2, compact = TRUE)) %in% c(
        "api",
        "connection",
        ignored_arguments,
        "function_identity"
      )
    ]

  switch(protocol,
    opencpu = {
      # Forward arguments to API via helper.
      do.call(
        forward_to_api,
        list(
          function_identity = function_identity,
          payload = arguments_to_pass,
          ...
        )
      )
    },
    localdb = {
      deployed_version <- get_etnservice_version(
        return_as = "version"
      ) |>
        as.character()
      # If the local and deployed etnservice versions do not match:
      if (!rlang::is_installed("etnservice", version = deployed_version)) {
        cli::cli_alert_info(
          glue::glue(
            "The API is using etnservice version {deployed_version}",
            "{local_situation_str}",
            "To ensure consistent results installing the same version as ",
            "the API is recommended.",
            deployed_version = deployed_version,
            local_situation_str = ifelse(
              rlang::is_installed("etnservice"),
              # If not installed, don't need to mention what version is
              # installed.
              no = ", no local installation could be found.",
              # If installed, create a string template to report what version.
              yes = glue::glue(", the locally installed version is: {local_version}. ",
                local_version = as.character(utils::packageVersion("etnservice"))
              )
            )
          ),
          class = "etn_etnservice_version_mismatch"
        )


        # We will need pak to install/update etnservice from GitHub
        rlang::check_installed("pak",
          reason = glue::glue(
            "to {update_or_install} etnservice.",
            update_or_install =
              ifelse(
                rlang::is_installed("etnservice"),
                yes = "update",
                no = "install"
              )
          )
        )

        # Update or install etnservice to the same version as deployed
        rlang::check_installed(
          "etnservice",
          version = deployed_version,
          # Ensure the exact version is installed, and not an even more recent
          # version (In case OpenCPU is lagging on the Github released version).
          compare = "==",
          reason = paste(
            "ensure consistent results,",
            glue::glue(
              "to {update_or_install} etnservice to version ",
              "{deployed_version} to ensure consistent results with the API.",
              update_or_install =
                ifelse(
                  rlang::is_installed("etnservice"),
                  yes = "update",
                  no = "install"
                ),
              deployed_version = as.character(deployed_version)
            ), "the version used by the API should match",
            "the locally installed version"
          ),
          # Because etnservice is not on CRAN we need to provide a function to
          # install it. The pkg and ... arguments are required by rlang.
          action = function(pkg, ...) {
            pak::pak(
              # The HEAD, tag, to install. By convention the tags for etnservice
              # start with v. If we ever diverge from this conversion, I need to
              # change this ref constructor.
              pkg = paste0("inbo/etnservice", "@v", deployed_version),
            )
          }
        )
      }

      # Forward the parent function to etnservice
      do.call(utils::getFromNamespace(function_identity, ns = "etnservice"),
        args = append(arguments_to_pass,
          list(credentials = get_credentials()),
          after = 0
        )
      )
    }
  )
}
