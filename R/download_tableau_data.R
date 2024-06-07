#' Download Tableau view data as Excel
#'
#' Downloads the data from a Tableau view in Excel format.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param view_id The ID of the view to download.
#' @param path_to_save The directory to write the data Excel file to.
#' @param api_version The API version to use (default: 3.8).
#' @param filters A named list of filters to apply to the view data. The names should be the field names, and the values should be the filter values.
#' @param max_age The maximum number of minutes view data will be cached before being refreshed (optional).
#'
#' @return NULL
#'
#' @details
#' This function uses the Tableau REST API to download data from a specified view in Excel format.
#' It constructs the appropriate URL, applies any specified filters, and saves the data to the specified path.
#'
#' For more information on the Tableau REST API, see the official documentation for this method:
#' \url{https://help.tableau.com/current/api/rest_api/en-us/REST/rest_api_ref.htm#query_view_data}
#'
#' @examples
#' \dontrun{
#' tableau <- list(
#'   base_url = "https://your-tableau-server.com/",
#'   token = "your-auth-token",
#'   user_id = "your-user-id",
#'   site_id = "your-site-id"
#' )
#' view_id <- "your-view-id"
#' path_to_save <- "path/to/save/"
#' filters <- list("Region" = "North America", "Category" = "Technology")
#' max_age <- 10
#' download_tableau_data(tableau, view_id, path_to_save, filters = filters, max_age = max_age)
#' }
#'
#' @export
#' @family Tableau REST API
download_tableau_data <- function(tableau, view_id, path_to_save, api_version = 3.8, filters = NULL, max_age = NULL) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  # Define the base URL
  base_url <- paste0(
    base_url, "api/", api_version, "/sites/",
    site_id, "/views/", view_id, "/data"
  )

  # Construct the URL with filters and maxAge
  url <- base_url
  params <- list()

  if (!is.null(filters)) {
    # URL encode filter names and values
    names(filters) <- sapply(names(filters), utils::URLencode, reserved = TRUE)
    filters <- sapply(filters, utils::URLencode, reserved = TRUE)
    filter_params <- paste0("vf_", names(filters), "=", filters, collapse = "&")
    params <- c(params, filter_params)
  }

  if (!is.null(max_age)) {
    params <- c(params, paste0("maxAge=", max_age))
  }

  if (length(params) > 0) {
    url <- paste0(url, "?", paste(params, collapse = "&"))
  }

  # Download the data as CSV
  httr::GET(
    url, httr::add_headers(`X-Tableau-Auth` = token),
    httr::write_disk(paste0(path_to_save, "data.csv"), overwrite = TRUE)
  )
}
