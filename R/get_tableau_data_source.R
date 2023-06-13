#' get tableau data source
#'
#' Search XMl for data source of tableau workbook
#'
#' @param dashboard path to Tableau twb file.
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
  source <- xml2::xml_find_all(data, "//@filename")
  return(xml2::xml_text(source))
}

