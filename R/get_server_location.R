#' Get the server location.
#'
#' @param wb The path to the Tableau workbook [.twb].
#'
#' @return The server location of the workbook.
#' @export
#'
#' @family xml
get_server_location <- function(wb) {
  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)

  xy <- which(nodenames == "repository-location")

  if (!length(xy)) {
    stop("The workbook is not hosted on the Tableau server")
  }

  server_location <- cbind(XML::xpathSApply(proc[[xy]], ".", XML::xmlGetAttr, "derived-from"))
  return(as.character(server_location))
}
