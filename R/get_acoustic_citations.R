#' Title
#'
#' @inheritParams get_animal_projects
#'
#' @returns The formatted citations for the animal project.
#' @export
#'
#' @examples
#' get_acoustic_citations("2004_Gudena")
get_acoustic_citations <- function(animal_project_code = NULL, api = TRUE) {
  # Query the imis dataset ids for the animal projects
  imis_dataset_ids <-
    get_animal_projects(
      animal_project_code = animal_project_code,
      api = api
    ) |>
    dplyr::pull("imis_dataset_id")

  # Query IMIS for the citations

  purrr::map(imis_dataset_ids, \(imis_dataset_id){
    httr2::request("https://vliz.be/en/imis") |>
      httr2::req_url_query(
        module = "dataset",
        dasid = imis_dataset_id,
        show=json
      )
  }) |>
    httr2::req_perform_sequential() |>
    purrr::map(httr2::resp_body_json)
}
