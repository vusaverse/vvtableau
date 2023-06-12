#' Download workbook from Tableau Server
#'
#' @param base_url The url of the Tableau Server.
#' @param api_version The api version; default set to 3.4
#' @param site_id The site id of the Tableau server to access.
#' @param token The access token to the Tableau Rest API.
#' @param workbook_id The identifier of the workbook.
#' @param path_to_save Where to write the .twb or .twbx file to.
#' @param include_extract Whether to include the extract file. Deafult set to FALES.
#' @importFrom magrittr %>%
#'
#' @return NULL.
#' @export
#'
#' @family tableau rest api
download_workbooks_server <- function(base_url, api_version = 3.4, site_id, token, workbook_id, path_to_save, include_extract = FALSE) {


  url <- paste0(base_url,
                "api/",
                api_version,
                "/sites/",
                site_id,
                "/workbooks/",
                workbook_id,
                "/content?includeExtract=",
                include_extract)

  api_response <- httr::GET(url,
                            httr::add_headers("X-Tableau-Auth" = token),
                            httr::write_disk(path_to_save))

}
