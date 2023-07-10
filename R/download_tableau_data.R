#' Download Tableau view data as Excel
#'
#' Downloads the data from a Tableau view in Excel format.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param view_id The ID of the view to download.
#' @param path_to_save The directory to write the data Excel file to.
#' @param api_version The API version to use (default: 3.8).
#'
#' @return NULL
#'
#' @export
#'
#' @family Tableau REST API
download_tableau_data <- function(tableau, view_id, path_to_save, api_version = 3.8) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  # Define the base URL
  base_url <- paste0(
    base_url, "api/", api_version, "/sites/",
    site_id, "/views/", view_id, "/data"
  )

  # Construct the URL
  url <- paste0(base_url, "?format=csv")

  # Download the data as CSV
  httr::GET(
    url, httr::add_headers(`X-Tableau-Auth` = token),
    httr::write_disk(paste0(path_to_save, "data.csv"), overwrite = TRUE)
  )
}
