#' Update Data Source Now
#'
#' Runs an extract refresh on the specified data source.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, and `site_id`.
#' @param datasource_id The ID of the data source to refresh.
#' @param api_version The API version to use (default: 3.22).
#'
#' @return The response from the API.
#' @export
#'
#' @family Tableau REST API
update_data_source_now <- function(tableau, datasource_id, api_version = 3.22) {
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
    "/refresh"
  )

  # Construct the request body
  # The request body is empty as per the requirements
  request_body <- "<tsRequest></tsRequest>"

  # Make the POST request to the Tableau REST API
  api_response <- httr::POST(
    url,
    httr::add_headers("X-Tableau-Auth" = token),
    body = request_body
  )

  return(api_response)
}
