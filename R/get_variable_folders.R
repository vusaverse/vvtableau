#' Get folder names
#'
#' @param wb The path to the Tableau workbook file [.twb].
#'
#' @return Dataframe containing the variable folder names
#' @export
#'
#' @family xml
get_variable_folders <- function(wb) {
  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)

  xy <- which(nodenames == "datasources")

  cc <- XML::getNodeSet(proc[[xy]], ".//folder")

  df <- data.table::rbindlist(lapply(cc, function(x) {
    r <- t(XML::xpathSApply(x, ".", XML::xmlAttrs))
    data.frame(r)
  }), fill = TRUE)

  return(df)
}
