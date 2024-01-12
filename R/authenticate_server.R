#' Authenticate on the Tableau server.
#'
#' Authenticates the user on the Tableau server and retrieves the necessary authentication variables for running other Tableau REST API methods.
#'
#' @param username The username on the Tableau server. Defaults to the `TABLEAU_USERNAME` environment variable.
#' @param password The password on the Tableau server. Defaults to the `TABLEAU_PASSWORD` environment variable.
#' @param base_url The base URL of the Tableau server. Defaults to the `TABLEAU_BASE_URL` environment variable.
#' @param api_version The API version to use (default: 3.4).
#'
#' @return A list containing the authentication variables: base_url, token, site_id, and user_id.
#' @export
#'
#' @family Tableau REST API
authenticate_server <- function(username = tableau_username(), password = tableau_password(), base_url = tableau_base_url(), api_version = 3.4) {
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

#' Get the Tableau username from the environment variable
#'
#' @return The Tableau username stored in the TABLEAU_USERNAME environment variable.
tableau_username <- function() {
  username <- Sys.getenv("TABLEAU_USERNAME")
  if (username == "") {
    stop("TABLEAU_USERNAME environment variable is not set.")
  }
  return(username)
}

#' Get the Tableau password from the environment variable
#'
#' @return The Tableau password stored in the TABLEAU_PASSWORD environment variable.
tableau_password <- function() {
  password <- Sys.getenv("TABLEAU_PASSWORD")
  if (password == "") {
    stop("TABLEAU_PASSWORD environment variable is not set.")
  }
  return(password)
}

#' Get the Tableau base URL from the environment variable
#'
#' @return The Tableau base URL stored in the TABLEAU_BASE_URL environment variable.
tableau_base_url <- function() {
  base_url <- Sys.getenv("TABLEAU_BASE_URL")
  if (base_url == "") {
    stop("TABLEAU_BASE_URL environment variable is not set.")
  }
  return(base_url)
}
