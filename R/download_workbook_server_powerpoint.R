#' Download workbook PowerPoint from Tableau Server.
#'
#' Downloads a PowerPoint version of a workbook from the Tableau Server using the provided authentication credentials and saves it to the specified path.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The API version to use (default: 3.8).
#' @param workbook_id The identifier of the workbook to download.
#' @param path_to_save The file path to save the downloaded PowerPoint file.
#'
#' @return NULL.
#' @export
#'
#' @family Tableau REST API
download_workbooks_server_powerpoint <- function(tableau, api_version = 3.8, workbook_id, path_to_save) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/workbooks/",
    workbook_id,
    "/powerpoint"
  )

  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token),
    httr::write_disk(path_to_save)
  )
}
