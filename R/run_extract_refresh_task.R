#' Run Extract Refresh Task
#'
#' Runs the specified extract refresh task on Tableau Server.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, and `site_id`.
#' @param task_id The ID of the extract refresh task to run.
#' @param api_version The API version to use (default: 3.22).
#'
#' @return The response from the API.
#' @export
#'
#' @family Tableau REST API
run_extract_refresh_task <- function(tableau, task_id, api_version = "3.22") {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/tasks/extractRefreshes/",
    task_id,
    "/runNow"
  )

  # Construct the request body
  # As per the requirements, the request body can be empty for now
  request_body <- "<tsRequest></tsRequest>"

  # Make the POST request to the Tableau REST API
  api_response <- httr::POST(
    url,
    httr::add_headers("X-Tableau-Auth" = token),
    body = request_body
  )

  return(api_response)
}
