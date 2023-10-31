#' Authenticate to Tableau Server or Tableau Cloud
#'
#' This function authenticates to a Tableau Server or Tableau Cloud using a personal access token (PAT).
#'
#' @param pat_name The name of the personal access token (PAT).
#' @param pat_secret The secret of the personal access token (PAT).
#' @param content_url The URL of the content to authenticate. For Tableau Server, this is typically the URL of the Tableau server followed by the site ID. For Tableau Cloud, this is usually the URL of the Tableau cloud workbook.
#' @param base_url The base URL of the Tableau server or Tableau cloud. For Tableau Server, this is usually the URL of the Tableau server. For Tableau Cloud, this is usually the URL of the Tableau cloud, and it must contain the pod name, such as 10az, 10ay, or us-east-1. For example, the base URL to sign in to a site in the 10ay pod would be: https://10ay.online.tableau.com.
#' @param api_version the api version to use. Default is 3.4
#' @return A list containing the base URL, the access token, the site ID, and the user ID.
authenticate_PAT <- function(pat_name, pat_secret, content_url, base_url, api_version = 3.4) {
  constructXML <- function(pat_name, pat_secret, content_url) {
    credentials <- paste0(
      "<credentials personalAccessTokenName=\"",
      pat_name,
      "\" personalAccessTokenSecret=\"",
      pat_secret,
      "\">")
    site <- paste0(
      "<site contentUrl=\"",
      content_url,
      "\"/>")
    tsRequest <- paste0(
      "<tsRequest>",
      credentials,
      site,
      "</credentials>",
      "</tsRequest>")
    return(tsRequest)
  }
  xml_request <- constructXML(pat_name, pat_secret, content_url)

  url <- paste0(base_url, "/api/", api_version, "/auth/signin")

  api_response <- httr::POST(url,
                             body = xml_request,
                             httr::verbose(),
                             httr::content_type("application/xml"),
                             httr::add_headers(`Accept` = "application/json"),
                             httr::accept_json())

  # Check the response status code
  if (httr::status_code(api_response) != 200) {
    stop("Authentication failed. Please check your API key and base URL.")
  }

  jsonResponseText <- httr::content(api_response, as = "text")

  dfauth <- as.data.frame(jsonlite::fromJSON(jsonResponseText), check.names = FALSE) %>%
    dplyr::rename_with(~ stringr::str_remove(., "credentials."), dplyr::everything())

  tableau <- list(
    base_url = base_url,
    token = dfauth$token,
    site_id = dfauth$site.id,
    user_id = dfauth$id
  )

  return(tableau)
}
