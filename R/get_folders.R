#' Get folder structure workbook
#'
#' @param wb The path to the Tableau workbook file [.twb].
#'
#' @return A dataframe containing the folder names and the variables stored inside.
#' @export
#'
#' @family xml
get_folders <- function(wb) {
  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)

  xy <- which(nodenames == "datasources")

  cc <- XML::getNodeSet(proc[[xy]], ".//folder")

  if (!length(cc)) {
    stop("The workbook does not contain any folders.")
  }

  df <- data.table::rbindlist(lapply(cc, function(x) {
    r <- t(XML::xpathSApply(x, ".", XML::xmlAttrs))
    var <- XML::xpathSApply(x, ".//folder-item", XML::xmlGetAttr, "name")
    data.frame(r, var)
  }), fill = TRUE)

  return(df)
}

