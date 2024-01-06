#' Update Group
#'
#' Updates a group on a Tableau Server or Tableau Cloud site.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, and `site_id`.
#' @param group_id The ID of the group to update.
#' @param group_name The new name for the group (optional).
#' @param AD_group_name The name of the Active Directory group to synchronize with (optional).
#' @param AD_domain The domain for the Active Directory group (optional).
#' @param minimum_site_role Required if an import element or grantLicenseMode attribute are present in the request. The site role assigned to users who are imported from Active Directory or granted a license automatically using the grant license on-sync or on-login mode.
#' @param license_mode Optional. The mode for automatically applying licenses for group members. When the mode is onLogin, a license is granted for each group member when they log in to a site.
#' @param on_demand_access Optional. A boolean value that is used to enable on-demand access for embedded Tableau content when the Tableau Cloud site is licensed with Embedded Analytics usage-based model.
#' @param asJob A Boolean value indicating whether to synchronize with Active Directory as a background task (true) or synchronize immediately (false). Default is false.
#' @param api_version The API version to use (default: 3.19).
#'
#' @return TRUE if the operation was successful, FALSE otherwise.
#' @export
#'
#' @family Tableau REST API
update_group <- function(tableau, group_id, group_name = NULL, AD_group_name = NULL, AD_domain = NULL, minimum_site_role = NULL, license_mode = NULL, on_demand_access = NULL, asJob = FALSE, api_version = 3.19) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "/api/",
    api_version,
    "/sites/",
    site_id,
    "/groups/",
    group_id,
    if (asJob) "?asJob=true" else ""
  )

  # Construct the request body
  request_body <- paste0(
    "<tsRequest>",
    "<group ",
    if (!is.null(group_name)) paste0("name=\"", group_name, "\" "),
    if (!is.null(AD_group_name)) paste0("AD-group-name=\"", AD_group_name, "\" "),
    if (!is.null(AD_domain)) paste0("AD-domain=\"", AD_domain, "\" "),
    if (!is.null(minimum_site_role)) paste0("minimum-site-role=\"", minimum_site_role, "\" "),
    if (!is.null(license_mode)) paste0("license-mode=\"", license_mode, "\" "),
    if (!is.null(on_demand_access)) paste0("on-demand-access=\"", on_demand_access, "\" "),
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
    stop("Group update failed. Please check your API key and base URL.")
  }

  return(TRUE)
}
