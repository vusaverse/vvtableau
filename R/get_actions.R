#' Get Workbook actions
#'
#' @param wb The path to the Tableau workbook [.twb].
#'
#' @return Dataframe containing the workbook actions.
#' @export
#'
#' @family xml
#' @examples
#' \dontrun{
#' # Get Workbook actions
#' actions <- get_actions(wb = "path/to/workbook.twb")
#' head(actions)
#' }
get_actions <- function(wb) {
  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)


  xy <- which(nodenames == "actions")
  if (!length(xy)) {
    stop("The workbook does not contain any actions.")
  }

  cc <- XML::getNodeSet(proc[[xy]], ".//action")



  z <- data.table::rbindlist(lapply(cc, function(x) {
    y <- t(XML::xpathSApply(x, ".", XML::xmlAttrs))
    r <- t(XML::xpathSApply(x, ".//activation", XML::xmlAttrs))
    s <- t(XML::xpathSApply(x, ".//source", XML::xmlAttrs))
    t <- t(XML::xpathSApply(x, ".//target", XML::xmlAttrs))
    data.frame(y, r, s, t)
  }), fill = TRUE)

  return(z)
}
