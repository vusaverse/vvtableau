#' Download workbook powerpoint from Tableau Server
#'
#' @param base_url The url of the Tableau Server.
#' @param api_version The api version; default set to 3.8 [this function works for version 3.8 and later].
#' @param site_id The site id of the Tableau server to access.
#' @param token The access token to the Tableau Rest API.
#' @param workbook_id The identifier of the workbook.
#' @param path_to_save Where to write the .pptx file to
#' @importFrom magrittr %>%
#'
#' @return NULL.
#' @export
#'
#' @family tableau rest api
download_workbooks_server_powerpoint <- function(base_url, api_version = 3.8, site_id, token, workbook_id, path_to_save) {


  url <- paste0(base_url,
                "api/",
                api_version,
                "/sites/",
                site_id,
                "/workbooks/",
                workbook_id,
                "/powerpoint")

  api_response <- httr::GET(url,
                            httr::add_headers("X-Tableau-Auth" = token),
                            httr::write_disk(path_to_save))

}

