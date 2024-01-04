#' Remove User from Group
#'
#' Removes a user from the specified group.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The version of the API to use, such as 3.19 (default: 3.19).
#' @param group_id The ID of the group to remove the user from.
#' @param user_id The ID of the user to remove.
#'
#' @return The response from the API.
#' @export
#' @family Tableau REST API
remove_user_from_group <- function(tableau, api_version = 3.19, group_id, user_id) {
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
    "/users/",
    user_id
  )

  api_response <- httr::DELETE(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )

  return(api_response)
}
