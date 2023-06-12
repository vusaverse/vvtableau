#' Get workbook tabs
#'
#' @param wb The path to the Tableau workbook file [.twb].
#'
#' @return Dataframe
#' @export
#'
#' @family xml
get_workbook_tabs <- function(wb) {
  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)

  xy <- which(nodenames == "windows")

  tab_name <- XML::xpathSApply(proc[[xy]], ".//window", XML::xmlGetAttr, "name")
  tab_type <- XML::xpathSApply(proc[[xy]], ".//window", XML::xmlGetAttr, "class")

  hidden <- cbind(XML::xpathSApply(proc[[xy]], ".//window", XML::xmlGetAttr, "hidden"))
  tab_color <- cbind(XML::xpathSApply(proc[[xy]], ".//window", XML::xmlGetAttr, "tab-color"))


  dfWorksheets <- data.table::data.table(data.frame(tab_name, tab_type, hidden, tab_color))


  return(dfWorksheets)
}
