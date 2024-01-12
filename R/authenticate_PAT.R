#' Authenticate to Tableau Server or Tableau Cloud
#'
#' This function authenticates to a Tableau Server or Tableau Cloud using a personal access token (PAT).
#'
#' @param pat_name The name of the personal access token (PAT). Defaults to the `TABLEAU_PAT_NAME` environment variable.
#' @param pat_secret The secret of the personal access token (PAT). Defaults to the `TABLEAU_PAT_SECRET` environment variable.
#' @param content_url The URL of the content to authenticate. Defaults to the `TABLEAU_CONTENT_URL` environment variable.
#' For Tableau Server, this is typically the URL of the Tableau server followed by the site ID. For Tableau Cloud, this is usually the URL of the Tableau cloud workbook.
#' @param base_url The base URL of the Tableau server or Tableau cloud. Defaults to the `TABLEAU_BASE_URL` environment variable.
#' For Tableau Server, this is usually the URL of the Tableau server. For Tableau Cloud, this is usually the URL of the Tableau cloud,
#' and it must contain the pod name, such as 10az, 10ay, or us-east-1.
#' For example, the base URL to sign in to a site in the 10ay pod would be: https://10ay.online.tableau.com.
#' @param api_version The API version to use. Default is 3.4.
#' @return A list containing the base URL, the access token, the site ID, and the user ID.
#' @export
#' @family Tableau REST API
authenticate_PAT <- function(pat_name = tableau_pat_name(), pat_secret = tableau_pat_secret(), content_url = tableau_content_url(), base_url = tableau_base_url(), api_version = 3.4) {
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


#' Get the Tableau PAT name from the environment variable
#'
#' @return The Tableau PAT name stored in the TABLEAU_PAT_NAME environment variable.
tableau_pat_name <- function() {
  pat_name <- Sys.getenv("TABLEAU_PAT_NAME")
  if (pat_name == "") {
    stop("TABLEAU_PAT_NAME environment variable is not set.")
  }
  return(pat_name)
}

#' Get the Tableau PAT secret from the environment variable
#'
#' @return The Tableau PAT secret stored in the TABLEAU_PAT_SECRET environment variable.
tableau_pat_secret <- function() {
  pat_secret <- Sys.getenv("TABLEAU_PAT_SECRET")
  if (pat_secret == "") {
    stop("TABLEAU_PAT_SECRET environment variable is not set.")
  }
  return(pat_secret)
}

#' Get the Tableau content URL from the environment variable
#'
#' @return The Tableau content URL stored in the TABLEAU_CONTENT_URL environment variable.
tableau_content_url <- function() {
  content_url <- Sys.getenv("TABLEAU_CONTENT_URL")
  if (content_url == "") {
    stop("TABLEAU_CONTENT_URL environment variable is not set.")
  }
  return(content_url)
}

