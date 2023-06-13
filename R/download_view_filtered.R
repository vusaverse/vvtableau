#' Download filtered tableau views to png images from dataframe
#'
#' @param df Dataframe containing filter columns and filter values
#' @param base_url Tableau server url
#' @param site_id The site id
#' @param token API token
#' @param view_id The id of the view to download
#' @param path_to_save The directory to write the images to
#' @return NULL.
#'
#' @export
download_filtered_tableau_image <- function(df, base_url, site_id, token, view_id, path_to_save) {
  # Define the base URL
  base_url <- paste0(base_url, "api/", "3.8", "/sites/",
                     site_id, "/views/", view_id , "/image")

  # Iterate over rows of the dataframe
  purrr::pmap(df, function(...) {
    name <- row_to_name(c(...))
    query <- row_to_query(c(...))
    url <- paste0(base_url, query, "&resolution=high")

    # # Download the image
    httr::GET(url, httr::add_headers(`X-Tableau-Auth` = token),
        httr::write_disk(paste0(path_to_save, name, ".png"), overwrite = TRUE))
  })

}

#' Escape characters for url
#'
#' @param url the url
#'
#' @return escaped string
escape_special_chars <- function(url) {
  url <- gsub(" ", "%20", url)
  url <- gsub(",", "%5C%2C", url)
  url <- gsub("&", "%26", url)
  url <- gsub("\\^", "%5E", url)
  return(url)
}

#' Dataframe row to query
#'
#' @param row row of dataframe
#'
#' @return Query to the api call
row_to_query <- function(row) {
  # Use paste to concatenate "vf_", column names, "=", and row values
  filter_strs <- paste0("vf_", names(row), "=", escape_special_chars(row))

  # Combine the filter strings with "&" and prepend "?"
  query <- paste0("?", paste(filter_strs, collapse = "&"))

  return(query)
}

#' Concat row to name
#'
#' @param row row of dataframe
#'
#' @return namr of the row
row_to_name <- function(row) {
  # Use paste to concatenate "vf_", column names, "=", and row values
  filter_strs <- paste0(as.character(row), collapse = "")

  # Combine the filter strings with "&" and prepend "?"
  query <- paste0((filter_strs))

  return(query)
}

