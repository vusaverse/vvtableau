#' Download a data source in .tdsx format using Tableau REST API and save it as a file.
#'
#' Downloads a data source in .tdsx format and saves it as a file on your computer.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The API version to use (default: 3.16).
#' @param datasource_id The ID of the data source to download.
#' @param file_path The path to save the downloaded data source.
#' @param include_extract Logical indicating whether to include the extract when downloading the data source (default: TRUE).
#' @return A binary vector containing the data source in .tdsx format.
#' @export
#' @family Tableau REST API
download_datasource <- function(tableau, api_version = 3.16, datasource_id, file_path, include_extract = TRUE) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/datasources/",
    datasource_id,
    "/content"
  )

  if (!include_extract) {
    url <- paste0(url, "?includeExtract=False")
  }

  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token),
    httr::write_disk(paste0(file_path, "data.tdsx"), overwrite = TRUE)
  )

}
