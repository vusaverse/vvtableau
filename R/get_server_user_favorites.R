#' Get favorites for a user from Tableau Server.
#'
#' Retrieves a list of favorite projects, data sources, views, workbooks, and flows for a specific user on Tableau Server.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param user_id The ID of the user for which you want to retrieve the favorites.
#' @param api_version The API version to use (default: 3.4).
#' @param page_size The number of items to return in one response (default: 100).
#' @param page_number The offset for paging (default: 1).
#'
#' @return A data frame containing the favorites for the specified user.
#' @export
#'
#' @family Tableau REST API
get_server_user_favorites <- function(tableau, user_id, api_version = 3.4, page_size = 100, page_number = 1) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  # Construct the URL for retrieving user favorites
  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/favorites/",
    user_id,
    "?pageSize=",
    page_size,
    "&pageNumber=",
    page_number
  )

  # Make the API request
  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )

  # Parse the JSON response
  jsonResponseText <- httr::content(api_response, as = "text")

  # Convert the JSON response to a data frame
  df <- as.data.frame(jsonlite::fromJSON(jsonResponseText), check.names = FALSE) %>%
    tidyr::unnest(names_sep = ".") %>%
    dplyr::rename_with(~ stringr::str_remove(., "favorites."), dplyr::everything())

  return(df)
}
