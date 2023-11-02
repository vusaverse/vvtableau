#' Get table assets from Tableau Server.
#'
#' Retrieves information about all table assets for a site from the Tableau Server using the provided authentication credentials.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The API version to use (default: 3.8).
#'
#' @return A data frame containing the table assets information.
#' @export
#'
#' @family Tableau REST API
get_table_assets <- function(tableau, api_version = 3.8) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/tables"
  )

  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )

  jsonResponseText <- httr::content(api_response, as = "text")

  df <- as.data.frame(jsonlite::fromJSON(jsonResponseText), check.names = FALSE)

  return(df)
}
