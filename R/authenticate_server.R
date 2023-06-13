#' Authenticate on the Tableau server.
#'
#' Authenticates the users and sets system variables.
#' These are necessary in order to run the other Tableau REST Api methods.
#'
#' @param username The username on the Tableau server.
#' @param password The password on the Tableau server.
#' @param base_url The base url of the Tableau server.
#' @param api_version The api version.
#'
#' @return Dataframe containing authentication variables
#' @export
#'
#' @family tableau rest api
#' @examples
#' \dontrun{
#' # Authenticate on the Tableau server
#' authenticate_server(username = "your_username",
#'                     password = "your_password",
#'                     base_url = "https://tableau.server.com",
#'                     api_version = 3.4)
#' }
#' # Check the set system variables
#' Sys.getenv("TABLEAU_API_TOKEN")
#' Sys.getenv("TABLEAU_API_SITE_ID")
#' Sys.getenv("TABLEAU_API_USER_ID")
authenticate_server <- function(username, password, base_url, api_version = 3.4) {

  credentials <- paste0('<credentials name="',
                        username,
                        '" password="',
                        password,
                        '">')

  xml_request <- paste('<tsRequest>',
                       credentials,
                       '<site contentUrl="" />',
                       '</credentials>',
                       '</tsRequest>',
                       collapse = '\n')

  url <- paste0(base_url,
                "api/",
                api_version,
                "/auth/signin")

  api_response <- httr::POST(url,
                             body = xml_request,
                             httr::verbose(),
                             httr::content_type("text/xml"))

  jsonResponseText <- httr::content(api_response, as = "text")

  df <- as.data.frame(jsonlite::fromJSON(jsonResponseText), check.names = FALSE) %>%
    dplyr::rename_with(~ stringr::str_remove(., "credentials."), dplyr::everything())

  Sys.setenv(TABLEAU_API_TOKEN = df$token)
  Sys.setenv(TABLEAU_API_SITE_ID = df$site.id)
  Sys.setenv(TABLEAU_API_USER_ID = df$id)

  message("The following system variables have been set: \n TABLEAU_API_TOKEN \n TABLEAU_API_SITE_ID \n TABLEAU_API_USER_ID")

  return(df)
}


