#' Query User On Site
#'
#' Returns information about the specified user.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, and `site_id`.
#' @param user_id The ID of the user to get information for.
#' @param api_version The API version to use (default: 3.19).
#'
#' @return Information about the specified user.
#' @export
#' @family Tableau REST API
query_user_on_site <- function(tableau, user_id, api_version = "3.19") {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "/api/",
    api_version,
    "/sites/",
    site_id,
    "/users/",
    user_id
  )

  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )

  # Check the response status code
  if (httr::status_code(api_response) != 200) {
    stop("Failed to query user on site. Please check your API key and base URL.")
  }

  jsonResponseText <- httr::content(api_response, as = "text")
  user_info <- jsonlite::fromJSON(jsonResponseText) %>%
    as.data.frame(check.names = FALSE)

  return(user_info)
}
