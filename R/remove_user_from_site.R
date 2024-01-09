#' Remove User from Site
#'
#' Removes a user from the specified site. The user will be deleted if they do not own any other assets other than subscriptions. If a user still owns content (assets) on Tableau Server, the user cannot be deleted unless the ownership is reassigned first.
#'
#' @param tableau A list containing the Tableau authentication variables: `base_url`, `token`, `user_id`, and `site_id`.
#' @param api_version The version of the API to use, such as 3.19 (default: 3.19).
#' @param user_id The ID of the user to remove.
#' @param mapAssetsTo Optional. The ID of a user that receives ownership of contents of the user being removed.
#'
#' @return No return value.
#' @export
#'
#' @family Tableau REST API
remove_user_from_site <- function(tableau, api_version = 3.19, user_id, mapAssetsTo = NULL) {
  base_url <- tableau$base_url
  token <- tableau$token
  site_id <- tableau$site_id

  url <- paste0(
    base_url,
    "api/",
    api_version,
    "/sites/",
    site_id,
    "/users/",
    user_id
  )

  if (!is.null(mapAssetsTo)) {
    url <- paste0(url, "?mapAssetsTo=", mapAssetsTo)
  }

  httr::DELETE(
    url,
    httr::add_headers("X-Tableau-Auth" = token)
  )
}
