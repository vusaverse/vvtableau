#' Update User
#'
#' Modifies information about the specified user.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, and `site_id`.
#' @param user_id The ID of the user to update.
#' @param fullName The new name for the user (optional).
#' @param email The new email address for the user (optional).
#' @param password The new password for the user (optional).
#' @param siteRole The new site role to assign to the user.
#' @param authSetting The authentication type for the user (optional).
#' @param api_version The API version to use (default: 3.19).
#'
#' @return TRUE if the operation was successful, FALSE otherwise.
#' @export
#'
#' @family Tableau REST API
update_user <- function(tableau, user_id, fullName = NULL, email = NULL, password = NULL, siteRole, authSetting = NULL, api_version = 3.19) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "/api/",
    api_version,
    "/sites/",
    site_id,
    "/users/",
    user_id
  )

  # Construct the request body
  request_body <- paste0(
    "<tsRequest>",
    "<user ",
    if (!is.null(fullName)) paste0("fullName=\"", fullName, "\" "),
    if (!is.null(email)) paste0("email=\"", email, "\" "),
    if (!is.null(password)) paste0("password=\"", password, "\" "),
    "siteRole=\"", siteRole, "\" ",
    if (!is.null(authSetting)) paste0("authSetting=\"", authSetting, "\" "),
    "/>",
    "</tsRequest>"
  )

  api_response <- httr::PUT(
    url,
    httr::add_headers("X-Tableau-Auth" = token),
    body = request_body
  )

  # Check the response status code
  if (httr::status_code(api_response) != 200) {
    stop("User update failed. Please check your API key and base URL.")
  }

  return(TRUE)
}
