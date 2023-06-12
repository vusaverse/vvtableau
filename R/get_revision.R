#' Get the revision number
#'
#' @param wb The path to the Tableau workbook file [.twb].
#'
#' @return The revision number
#' @export
#'
#' @family xml
get_revision <- function(wb) {
  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)

  xy <- which(nodenames == "repository-location")

  Revision <- cbind(XML::xpathSApply(proc[[xy]], ".", XML::xmlGetAttr, "revision"))
  return(as.double(Revision))
}
