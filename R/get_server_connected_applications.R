#' Get connected applications from Tableau Server
#'
#' @param base_url The url of the Tableau Server.
#' @param api_version The api version; default set to 3.14 [Version 3.14 and later.]
#' @param site_id The site id of the Tableau server to access.
#' @param token The access token to the Tableau Rest API.
#' @param page_size Number of records to return; default is set to 100.
#' @importFrom magrittr %>%
#'
#' @return Dataframe containing information on connected applications.
#' @export
#'
#' @family tableau rest api
get_server_connected_apps <- function(base_url, api_version = 3.14, site_id, token, page_size = 100) {


  url <- paste0(base_url,
                "api/",
                api_version,
                "/sites/",
                site_id,
                "/connected-applications")

  api_response <- httr::GET(url,
                            httr::add_headers("X-Tableau-Auth" = token))

  jsonResponseText <- httr::content(api_response, as = "text")

  df <- as.data.frame(jsonlite::fromJSON(jsonResponseText), check.names = FALSE)

  return(df)
}
