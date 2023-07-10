#' Download Tableau view crosstab as Excel
#'
#' Downloads the crosstab data from a Tableau view in Excel format.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param view_id The ID of the view to download.
#' @param path_to_save The directory to write the crosstab Excel file to.
#' @param api_version The API version to use (default: 3.16).
#'
#' @return NULL
#' @family Tableau REST API
#'
#' @export
download_tableau_crosstab_excel <- function(tableau, view_id, path_to_save, api_version = 3.16) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  # Define the base URL
  base_url <- paste0(base_url, "api/", api_version, "/sites/", site_id, "/views/", view_id, "/crosstab/excel")

  # Download the crosstab as Excel
  httr::GET(
    base_url, httr::add_headers("X-Tableau-Auth" = token),
    httr::write_disk(paste0(path_to_save, "crosstab.xlsx"), overwrite = TRUE)
  )
}
