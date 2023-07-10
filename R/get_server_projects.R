#' Get projects from Tableau server.
#'
#' Retrieves a list of projects from the Tableau server using the provided authentication credentials.
#'
#' @param tableau A list containing the Tableau authentication variables: base_url, token, site_id, and user_id.
#' @param api_version The API version to use (default: "3.4").
#' @param page_size The number of projects to retrieve per page (default: 100).
#' @param include_metadata Logical indicating whether to include metadata columns in the result (default: FALSE).
#'
#' @return A data frame containing the projects information.
#' @export
#'
#' @family Tableau REST API
get_server_projects <- function(tableau, api_version = "3.4", page_size = 100, include_metadata = FALSE) {
  base_url <- tableau$base_url
  token <- tableau$token
  user_id <- tableau$user_id
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/projects?fields=_all_&pageSize=",
    page_size
  )

  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )

  jsonResponseText <- httr::content(api_response, as = "text")

  df <- jsonlite::fromJSON(jsonResponseText) %>%
    as.data.frame(check.names = FALSE) %>%
    dplyr::rename_all(~ stringr::str_remove(., "projects.project."))

  if (!include_metadata) {
    df <- df %>%
      dplyr::select(-dplyr::starts_with("pagination"))
  }

  return(df)
}
