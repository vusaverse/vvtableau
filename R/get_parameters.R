#' Get all parameters in workbook.
#'
#' @param wb The path to the tableau workbook [.twb].
#'
#' @return Dataframe
#' @export
#'
#' @family xml
get_parameter <- function(wb) {

  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)

  xy <- which(nodenames == "datasources")

  cc <- XML::getNodeSet(proc[[xy]][[1]], ".//column")

  df <- data.table::rbindlist(lapply(cc, function(xz) {
    ab <- t(XML::xpathSApply(xz, paste0("."), XML::xmlAttrs))
    ad <- t(XML::xpathSApply(xz, paste0(".//range"), XML::xmlAttrs))
    ae <- t(XML::xpathSApply(xz, paste0(".//members//member"), XML::xmlAttrs))
    data.frame(ab, ad, ae)
  }), fill = TRUE)

  return(df)

}

