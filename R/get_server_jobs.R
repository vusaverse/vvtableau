#' Title
#'
#' @param base_url The url of the Tableau Server.
#' @param api_version The api version; default set to 3.4
#' @param site_id The site id of the Tableau server to access.
#' @param token The access token to the Tableau Rest API.
#' @param page_size Number of records to return; default is set to 100.
#' @param include_metadata Whether to include metadata; default is set to FALSE
#' @importFrom magrittr %>%
#'
#' @return Dataframe containing information on server jobs.
#' @export
#'
#' @family tableau rest api
#' @examples
#' \dontrun{
#' # Get server jobs
#' jobs <- get_server_jobs(base_url = "https://tableau.server.com",
#'                         api_version = 3.4,
#'                         site_id = "your_site_id",
#'                         token = "your_access_token",
#'                         page_size = 100,
#'                         include_metadata = FALSE)
#' head(jobs)
#' }
get_server_jobs <- function(base_url, api_version = 3.4, site_id, token, page_size = 100, include_metadata = FALSE) {


  url <- paste0(base_url,
                "api/",
                api_version,
                "/sites/",
                site_id,
                "/jobs?fields=_all_&pageSize=",
                page_size)

  api_response <- httr::GET(url,
                      httr::add_headers("X-Tableau-Auth" = token))

  jsonResponseText <- httr::content(api_response, as = "text")

  df <- as.data.frame(jsonlite::fromJSON(jsonResponseText)) %>%
    dplyr::rename_with(~ stringr::str_remove(., "backgroundJobs.backgroundJob."), dplyr::everything())

  if (!include_metadata) {
    df <- df %>%
      dplyr::select(-dplyr::starts_with("pagination"))
  }

  return(df)
}

