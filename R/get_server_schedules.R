#' Get schedules from Tableau server.
#'
#' Retrieves a list of schedules from the Tableau server using the provided authentication credentials.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url` and `token`.
#' @param api_version The API version to use (default: 3.4).
#' @param page_size The number of records to retrieve per page (default: 100).
#' @param include_metadata Logical indicating whether to include metadata columns in the result (default: FALSE).
#'
#' @return A data frame containing the schedules information.
#' @export
#'
#' @family Tableau REST API
get_server_schedules <- function(tableau, api_version = 3.4, page_size = 100, include_metadata = FALSE) {
  base_url <- tableau$base_url
  token <- tableau$token

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/schedules?fields=_all_&pageSize=",
    page_size
  )

  api_response <- httr::GET(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )

  jsonResponseText <- httr::content(api_response, as = "text")

  df <- jsonlite::fromJSON(jsonResponseText) %>%
    as.data.frame() %>%
    dplyr::rename_with(~ stringr::str_remove(., "schedules.schedule."), dplyr::everything())

  if (!include_metadata) {
    df <- df %>%
      dplyr::select(-dplyr::starts_with("pagination"))
  }

  return(df)
}
