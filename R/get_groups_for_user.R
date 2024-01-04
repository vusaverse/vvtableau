#' Get Groups for a User
#'
#' Gets a list of groups that the specified user is a member of.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The API version to use (default: 3.19).
#' @param user_id The ID of the user whose group memberships are listed.
#' @param page_size
#' (Optional) The number of items to return in one response. The minimum is 1. The maximum is 1000. The default is 100. For more information, see Paginating Results.
#' @param page_number
#' (Optional) The offset for paging. The default is 1. For more information, see Paginating Results.
#' @param include_metadata Logical indicating whether to include metadata columns in the result (default: FALSE).
#'
#' @return A table containing the groups for the specified user.
#' @export
#' @family Tableau REST API
get_groups_for_user <- function(tableau, api_version = 3.19, user_id, page_size = 100, page_number = 1, include_metadata = FALSE) {
  base_url <- tableau$base_url
  site_id <- tableau$site_id
  token <- tableau$token

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/users/",
    user_id,
    "/groups"
  )

  api_response <- httr::GET(url,
                            httr::add_headers("X-Tableau-Auth" = token),
                            httr::content_type("application/xml"),
                            httr::accept_json())

  if (httr::status_code(api_response) != 200) {
    stop("API call failed.")
  }

  jsonResponseText <- httr::content(api_response, as = "text")

  df <- jsonlite::fromJSON(jsonResponseText) %>%
    as.data.frame(check.names = FALSE) %>%
    dplyr::rename_with(~ stringr::str_remove(., "groups.group."), dplyr::everything())

  if (!include_metadata) {
    df <- df %>%
      dplyr::select(-dplyr::starts_with("pagination"))
  }

  return(df)
}
