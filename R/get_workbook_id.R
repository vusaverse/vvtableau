#' Get workbook ID name.
#'
#' @param wb The path to the Tableau workbook [.twb].
#'
#' @return The ID name of the workbook.
#' @export
#'
#' @family xml
get_workbook_id <- function(wb) {
  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)

  xy <- which(nodenames == "repository-location")

  ID <- cbind(XML::xpathSApply(proc[[xy]], ".", XML::xmlGetAttr, "id"))
  return(as.character(ID))
}
