#' Get all nodenames
#'
#' @param proc The rootnode
#'
#' @return nodenames
#' @export
#'
#' @family xml
get_nodenames <- function(proc) {
  nodenames <- vapply(seq_along(XML::xmlChildren(proc)), function(x) {
    XML::xmlName(proc[[x]])
  }, character(1))

  return(nodenames)
}
