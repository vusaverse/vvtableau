#' Get variable names from workbook.
#'
#' @param wb The path to the Tableau workbook file [.twb].
#'
#' @return Dataframe
#' @export
#'
#' @family xml
get_variables <- function(wb) {
  proc <- make_rootnodes(wb)

  nodenames <- get_nodenames(proc)

  xy <- which(nodenames == "datasources")

  var_ordinal <- XML::xpathSApply(proc[[xy]], "//workbook//datasource//column", XML::xmlGetAttr, "ordinal")
  var_caption <- XML::xpathSApply(proc[[xy]], "//workbook//datasource//column", XML::xmlGetAttr, "caption")
  var_data_type <- XML::xpathSApply(proc[[xy]], "//workbook//datasource//column", XML::xmlGetAttr, "datatype")
  var_format <- XML::xpathSApply(proc[[xy]], "//workbook//datasource//column", XML::xmlGetAttr, "default-format")
  var_name <- XML::xpathSApply(proc[[xy]], "//workbook//datasource//column", XML::xmlGetAttr, "name")
  var_role <- XML::xpathSApply(proc[[xy]], "//workbook//datasource//column", XML::xmlGetAttr, "role")
  var_type <- XML::xpathSApply(proc[[xy]], "//workbook//datasource//column", XML::xmlGetAttr, "type")
  par_value <- XML::xpathSApply(proc[[xy]], "//workbook//datasource//column", XML::xmlGetAttr, "value")

  ## TEMP: get nested xml tags
  utilFun <- function(x) {
    attributess <- list(sapply(XML::xmlChildren(x, omitNodeTypes = "XMLInternalTextNode"), XML::xmlAttrs))
  }

  result <- XML::xpathApply(proc[[xy]], "//workbook//datasource//column", utilFun)
  nested_xml <- do.call(rbind, result)


  df <- data.frame(
    var_name,
    nested_xml
  ) %>%
    tidyr::unnest_wider(nested_xml) %>%
    dplyr::mutate(
      role = var_role,
      ordinal = var_ordinal,
      caption = var_caption,
      datatype = var_data_type,
      format = var_format,
      thetype = var_type,
      thevalue = par_value
    )

  return(df)
}
