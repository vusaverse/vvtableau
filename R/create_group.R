#' Create Group
#'
#' Creates a group on Tableau Server or Tableau Cloud site.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, and `site_id`.
#' @param group_name The name of the group to create.
#' @param api_version The API version to use (default: 3.19).
#'
#' @return The ID of the new group.
#' @export
#'
#' @family Tableau REST API
create_group <- function(tableau, group_name, api_version = 3.19) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "/api/",
    3.19,
    "/sites/",
    site_id,
    "/groups"
  )

  # Construct the request body
  request_body <- paste0(
    "<tsRequest>",
    "<group name=\"", group_name, "\"/>",
    "</tsRequest>"
  )

  api_response <- httr::POST(
    url,
    httr::add_headers("X-Tableau-Auth" = token),
    body = request_body
  )

  # Check the response status code
  if (httr::status_code(api_response) != 201) {
    stop("Group creation failed. Please check your API key and base URL.")
  }

  # Extract the ID of the new group from the Location header
  location_header <- httr::headers(api_response)$location
  group_id <- stringr::str_extract(location_header, "\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}")

  return(group_id)
}
