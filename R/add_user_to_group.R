#' Add User to Group
#'
#' Adds a user to the specified group.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The version of the API to use, such as 3.19 (default: 3.19).
#' @param group_id The ID of the group to add the user to.
#' @param user_id The ID (not name) of the user to add. You can get the user ID by calling Get Users on Site.
#'
#' @return The response from the API.
#' @export
#' @family Tableau REST API
add_user_to_group <- function(tableau, api_version = 3.19, group_id, user_id) {
  base_url <- tableau$base_url
  site_id <- tableau$site_id
  token <- tableau$token

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/groups/",
    group_id,
    "/users"
  )

  request_body <- paste0(
    "<tsRequest>",
    "<user id=\"", user_id, "\" />",
    "</tsRequest>"
  )

  api_response <- httr::POST(
    url,
    httr::add_headers("X-Tableau-Auth" = token),
    body = request_body
  )

  return(api_response)
}
