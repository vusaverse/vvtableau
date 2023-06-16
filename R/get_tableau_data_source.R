#' Get Tableau data source
#'
#' Search XML for data source of Tableau workbook
#'
#' @param dashboard Path to Tableau twb file.
#'
#' @return Data source of the workbook
#' @export
#' @family xml
#' @examples
#' \dontrun{
#' # Get Tableau data source
#' data_source <- get_tableau_data_source(dashboard = "path/to/workbook.twb")
#' print(data_source)
#' }
get_tableau_data_source <- function(dashboard) {
  data <- xml2::read_xml(dashboard)
  data_source <- xml2::xml_find_all(data, "//@filename")
  return(xml2::xml_text(data_source))
}
