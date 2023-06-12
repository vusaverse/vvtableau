#' Get Workbook drilldown hierarchies
#'
#' @param wb The path to the Tableau workbook [.twb].
#'
#' @return Dataframe containing the workbook hierarchy drill downs.
#' @export
#'
#' @family xml
get_hierarchy <- function(wb) {
  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)


  xy <- which(nodenames == "datasources")


  cc <- XML::getNodeSet(proc[[xy]], ".//drill-paths")
  if (!length(xy)) {
    stop("The workbook does not contain any hierarchy drilldowns")
  }

  df <- data.table::rbindlist(lapply(cc, function(x) {
    r <- t(XML::xpathSApply(x, ".//drill-path", XML::xmlAttrs))
    var <- t(XML::xpathSApply(x, ".//drill-path", XML::getChildrenStrings))
    data.frame(r, var)
  }), fill = TRUE)

  return(df)

}
