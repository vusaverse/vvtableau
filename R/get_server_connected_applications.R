#' Get connected applications from Tableau Server.
#'
#' Retrieves information about connected applications from the Tableau Server using the provided authentication credentials.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The API version to use (default: 3.14).
#' @param page_size The number of records to retrieve per page (default: 100).
#'
#' @return A data frame containing the connected applications information.
#' @export
#'
#' @family Tableau REST API
get_server_connected_apps <- function(tableau, api_version = 3.14, page_size = 100) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/connected-applications"
  )

  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )

  jsonResponseText <- httr::content(api_response, as = "text")

  df <- as.data.frame(jsonlite::fromJSON(jsonResponseText), check.names = FALSE)

  return(df)
}
