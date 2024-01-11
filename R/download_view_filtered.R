#' Download filtered Tableau views to PNG images from a dataframe.
#'
#' Downloads PNG images of filtered Tableau views based on the provided dataframe containing filter columns and filter values.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param df Dataframe containing filter columns and filter values.
#' @param view_id The ID of the view to download.
#' @param path_to_save The directory to write the images to.
#' @param api_version The API version to use (default: 3.8).
#'
#' @export
#'
#' @family Tableau REST API
download_filtered_tableau_image <- function(tableau, df, view_id, path_to_save, api_version = 3.8) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  # Define the base URL
  base_url <- paste0(
    base_url, "api/", api_version, "/sites/",
    site_id, "/views/", view_id, "/image"
  )

  # Iterate over rows of the dataframe
  purrr::pmap(df, function(...) {
    name <- row_to_name(c(...))
    query <- row_to_query(c(...))
    url <- paste0(base_url, query, "&resolution=high")

    # Download the image
    httr::GET(
      url, httr::add_headers(`X-Tableau-Auth` = token),
      httr::write_disk(paste0(path_to_save, name, ".png"), overwrite = TRUE)
    )
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
