#' Get Users in Group
#'
#' Gets a list of users in the specified group.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The version of the API to use, such as 3.21.
#' @param group_id The ID of the group to get the users for.
#' @param page_size The number of items to return in one response. The minimum is 1. The maximum is 1000. The default is 100.
#' @param page_number The offset for paging. The default is 1.
#'
#' @return A list of users in the specified group.
#'
#' @family Tableau REST API
get_users_in_group <- function(tableau, api_version = 3.19, group_id, page_size = 100, page_number = 1) {
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
    "/users",
    "?pageSize=",
    page_size,
    "&pageNumber=",
    page_number
  )

  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )

  # Check the response status code
  if (httr::status_code(api_response) != 200) {
    stop("Failed to get users in group. Please check your API key and base URL.")
  }

  jsonResponseText <- httr::content(api_response, as = "text")

  users <- jsonlite::fromJSON(jsonResponseText)$users$user

  return(users)
}
