#' Download Tableau view crosstab as Excel
#'
#' @param base_url Tableau server URL
#' @param api_version The API version; default set to 3.16
#' @param site_id The site ID
#' @param token API token
#' @param view_id The ID of the view to download
#' @param path_to_save The directory to write the crosstab Excel file to
#'
#' @return NULL
#' @family tableau rest api
#'
#' @export
download_tableau_crosstab_excel <- function(base_url, site_id, token, view_id, path_to_save, api_version = 3.16) {
  # Define the base URL
  base_url <- paste0(base_url, "api/", api_version, "/sites/", site_id, "/views/", view_id, "/crosstab/excel")

  # Download the crosstab as Excel
  httr::GET(base_url, httr::add_headers("X-Tableau-Auth" = token),
            httr::write_disk(paste0(path_to_save, "crosstab.xlsx"), overwrite = TRUE))
}
