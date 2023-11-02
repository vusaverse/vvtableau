#' Add tags to a view in Tableau Server.
#'
#' Adds one or more tags to the specified view in the Tableau Server using the provided authentication credentials.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The API version to use (default: 3.8).
#' @param view_id The ID of the view to add tags to.
#' @param tags A vector of tags to add to the view.
#'
#' @return The response from the API.
#' @export
#'
#' @family Tableau REST API
add_tags_to_view <- function(tableau, api_version = 3.8, view_id, tags) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/views/",
    view_id,
    "/tags"
  )

  # Construct the request body
  request_body <- paste0(
    "<tsRequest>",
    "<tags>",
    paste0(
      "<tag label=\"", tags, "\" />",
      collapse = ""
    ),
    "</tags>",
    "</tsRequest>"
  )

  api_response <- httr::PUT(
    url,
    httr::add_headers("X-Tableau-Auth" = token),
    body = request_body,
    encode = "xml"
  )

  return(api_response)
}
