#' Update Workbook Now
#'
#' Refreshes the specified workbook.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, and `site_id`.
#' @param workbook_id The ID of the workbook to refresh.
#' @param api_version The API version to use (default: 3.22).
#'
#' @return The response from the API.
#' @export
#'
#' @family Tableau REST API
update_workbook_now <- function(tableau, workbook_id, api_version = 3.22) {
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
