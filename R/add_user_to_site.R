#' Add User to Site
#'
#' Adds a user to Tableau Server or Tableau and assigns the user to the specified site.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param site_role The site role to assign to the user.
#' @param user_name The name of the user to add.
#' @param auth_setting The authentication type for the user.
#' @param api_version The API version to use (default: 3.19).
#'
#' @return The response from the API.
#' @export
#'
#' @family Tableau REST API
add_user_to_site <- function(tableau, site_role, user_name, auth_setting = NULL, api_version = 3.19) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/users"
  )

  # Construct the request body
  request_body <- paste0(
    "<tsRequest>",
    "<user name=\"", user_name, "\"",
    " siteRole=\"", site_role, "\"",
    if (!is.null(auth_setting)) {
      paste0(" authSetting=\"", auth_setting, "\"")
    },
    "/>",
    "</tsRequest>"
  )

  # Check if the site role is valid
  valid_roles <- c("Creator", "Explorer", "ExplorerCanPublish", "SiteAdministratorExplorer", "SiteAdministratorCreator", "Unlicensed", "Viewer")
  if (!(site_role %in% valid_roles)) {
    stop("Invalid site role. Please choose one of the following: Creator, Explorer, ExplorerCanPublish, SiteAdministratorExplorer, SiteAdministratorCreator, Unlicensed, Viewer.")
  }

  api_response <- httr::POST(
    url,
    httr::add_headers("X-Tableau-Auth" = token),
    body = request_body
    )

  return(api_response)
}
