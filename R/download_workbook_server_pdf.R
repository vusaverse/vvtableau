#' Download workbook pdf from Tableau Server
#'
#' @param base_url The url of the Tableau Server.
#' @param api_version The api version; default set to 3.4
#' @param site_id The site id of the Tableau server to access.
#' @param token The access token to the Tableau Rest API.
#' @param workbook_id The identifier of the workbook.
#' @param path_to_save Where to write the pdf file to
#' @importFrom magrittr %>%
#'
#' @return NULL.
#' @export
#'
#' @family tableau rest api
#' @examples
#' \dontrun{
#' # Download workbook PDF from Tableau Server
#' download_workbooks_server_pdf(base_url = "https://tableau.server.com",
#'                               api_version = 3.4,
#'                               site_id = "your_site_id",
#'                               token = "your_access_token",
#'                               workbook_id = "your_workbook_id",
#'                               path_to_save = "path/to/save/file.pdf")
#' }
download_workbooks_server_pdf <- function(base_url, api_version = 3.4, site_id, token, workbook_id, path_to_save) {


  url <- paste0(base_url,
                "api/",
                api_version,
                "/sites/",
                site_id,
                "/workbooks/",
                workbook_id,
                "/pdf")

  api_response <- httr::GET(url,
                            httr::add_headers("X-Tableau-Auth" = token),
                            httr::write_disk(path_to_save))

}
