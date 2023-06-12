#' check_dashboard_names
#'
#' Check the names of dashboards in tableau, according to the style guide.
#' The wrong dashboards will be returned together with the reason why it is a
#' wrong name
#'
#' @param import_files selected tableau file or folder,
#' to check the names of the dashboards.
#' If it is only one file, make sure it is a twb file.
#'
#' @return the wrongly named dashboards
#' @export
#' @family xml
check_dashboard_names <- function(import_files) {
  if (tools::file_ext(import_files) != "twb") {
    import_files = list.files(import_files, full.names = TRUE)
  }
  for (file in import_files) {
    data <- XML::xmlParse(file = file)

    ## Extract de root node.
    rootnode <- XML::xmlRoot(data)

    ## Find the dashboards part
    DB_part <- rootnode[["dashboards"]]

    ## Find the amount of dashboards
    number_of_DB <- length(XML::xmlChildren(DB_part))

    ## while loop over all DB's to save each dashboards current name
    count <- 1
    name_list <- list()

    while (count <= number_of_DB) {
      DB_names <- rootnode[["dashboards"]][[count]]
      name_list <- append(name_list, XML::xmlAttrs(DB_names))
      count <- count + 1
    }

    ## check all conditions for a correct DB name
    names <- 1
    while (names <= number_of_DB) {

      if (name_list[names] == "Filters" || name_list[names] == "Toelichting") {
        ## do nothing, it is a correct name, so skip it.
      }

      else if (name_list[names] == "filters" || name_list[names] == "toelichting") {
        message(paste0("Wrong DB name: '", name_list[names], "', not starting with an capital letter"))
      }

      else if (stringr::str_detect(name_list[names], "^\\d.") == F) {
        message(paste0("Wrong DB name: '", name_list[names],"', not starting with a digit and a dot"))
      }

      else if (stringr::str_detect(name_list[names], "[A-Z]") == F) {
        message(paste0("Wrong DB name: '", name_list[names], "', not starting with an capital letter"))
      }

      else if (grepl("DB", name_list[names]) == T) {
        message(paste0("Wrong DB name: '", name_list[names], "', no 'DB' allowed in DB name"))
      }
      names <- names + 1
    }
  }
}
