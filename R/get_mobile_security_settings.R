#' Get mobile security settings for the server using Tableau REST API.
#'
#' Retrieves the mobile security settings for the Tableau Server.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`.
#' @param api_version The API version to use (default: 3.19).
#' @return A list containing the mobile security settings for the server.
#' @export
#' @family Tableau REST API
get_mobile_security_settings <- function(tableau, api_version = 3.19) {
  base_url <- tableau$base_url
  token <- tableau$token

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/settings/mobilesecuritysettings"
  )

  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )

  jsonResponseText <- httr::content(api_response, as = "text")

  settings <- jsonlite::fromJSON(jsonResponseText)

  return(settings)
}
