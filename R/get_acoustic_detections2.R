page_size <- 100000
# prep progress bar
n_records <-
  get_acoustic_detections_page(animal_project_code = "Friesland", count = TRUE)$count
cli::cli_progress_bar(total = n_records,
                      format_done = "Detections fetched")
# prep for fetching
next_id_pk <- 0
page <- 1
combined_results <- list()
repeat {
  fetched_page <-
    get_acoustic_detections_page(
      next_id_pk = next_id_pk,
      animal_project_code = "Friesland",
      page_size = page_size
    )
  next_id_pk <- max(fetched_page$detection_id_pk)
  combined_results[[page]] <- fetched_page
  cli::cli_progress_update(inc = nrow(fetched_page))
  page <- page + 1
  dplyr::bind_rows(combined_results)

  if (nrow(fetched_page) < page_size) {
    break
  }
}

dplyr::bind_rows(combined_results) %>%
  dplyr::glimpse()

