#' Delete Group
#'
#' Deletes the specified group from the site.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param group_id The ID of the group to delete.
#' @param api_version The API version to use (default: 3.19).
delete_group <- function(tableau, group_id, api_version = 3.19) {
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
    group_id
  )

  api_response <- httr::DELETE(url,
                               httr::add_headers("X-Tableau-Auth" = token)
  )

  # Check the response status code
  if (httr::status_code(api_response) != 204) {
    stop("Group deletion failed. Please check your API key and base URL.")
  }
}
