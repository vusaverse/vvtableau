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
  
  # Find all nodes with filename attribute
  filename_nodes <- xml2::xml_find_all(data, "//@filename")
  # Extract text from filename nodes
  filename_values <- xml2::xml_text(filename_nodes)
  
  # Find all nodes with directory attribute
  directory_nodes <- xml2::xml_find_all(data, "//@directory")
  # Extract text from directory nodes
  directory_values <- xml2::xml_text(directory_nodes)
  
  # Return filename and directory values combined as one file path string
  return(path = paste0(directory_values, "/", filename_values))
}
