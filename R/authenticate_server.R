#' Authenticate on the Tableau server.
#'
#' Authenticates the user on the Tableau server and retrieves the necessary authentication variables for running other Tableau REST API methods.
#'
#' @param username The username on the Tableau server.
#' @param password The password on the Tableau server.
#' @param base_url The base URL of the Tableau server.
#' @param api_version The API version to use (default: 3.4).
#'
#' @return A list containing the authentication variables: base_url, token, site_id, and user_id.
#' @export
#'
#' @family Tableau REST API
authenticate_server <- function(username, password, base_url, api_version = 3.4) {
  tableau <- list(base_url = base_url)

  # Check if the base URL ends with a trailing slash and remove it if present
  if (substr(tableau$base_url, nchar(tableau$base_url), nchar(tableau$base_url)) == "/") {
    tableau$base_url <- substr(tableau$base_url, 1, nchar(tableau$base_url) - 1)
  }


  credentials <- paste0(
    '<credentials name="',
    username,
    '" password="',
    password,
    '">'
  )

  xml_request <- paste("<tsRequest>",
    credentials,
    '<site contentUrl="" />',
    "</credentials>",
    "</tsRequest>",
    collapse = "\n"
  )

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/auth/signin"
  )

  api_response <- httr::POST(url,
    body = xml_request,
    httr::verbose(),
    httr::content_type("text/xml")
  )

  # Check the response status code
  if (httr::status_code(api_response) != 200) {
    stop("Authentication failed. Please check your API key and base URL.")
  }

  jsonResponseText <- httr::content(api_response, as = "text")

  dfauth <- as.data.frame(jsonlite::fromJSON(jsonResponseText), check.names = FALSE) %>%
    dplyr::rename_with(~ stringr::str_remove(., "credentials."), dplyr::everything())


  tableau <- list(
    base_url = base_url,
    token = dfauth$token,
    site_id = dfauth$site.id,
    user_id = dfauth$id
  )

  return(tableau)
}
