#' Download Tableau view data as Excel
#'
#' @param base_url Tableau server URL
#' @param api_version The API version; default set to 3.8
#' @param site_id The site ID
#' @param token API token
#' @param view_id The ID of the view to download
#' @param path_to_save The directory to write the data Excel file to
#'
#' @return NULL
#'
#' @export
download_tableau_data <- function(base_url, site_id, token, view_id, path_to_save, api_version = 3.8) {
  # Define the base URL
  base_url <- paste0(base_url, "api/", api_version, "/sites/",
                     site_id, "/views/", view_id , "/data")

  # Construct the URL
  url <- paste0(base_url, "?format=csv")

  # Download the crosstab
  httr::GET(url, httr::add_headers(`X-Tableau-Auth` = token),
            httr::write_disk(paste0(path_to_save, "data.csv"), overwrite = TRUE))
}
