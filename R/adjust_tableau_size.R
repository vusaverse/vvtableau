#' adjust_tableau_size
#'
#' Adjust the size of selected tableau file/files.
#'
#' @param import_files selected tableau file or folder, to change its size. If
#'  it is only one file, make sure it is a twb file.
#' @param save_location The location to which the adjusted tableau file will be
#' saved (this needs to be a .twb file). If empty, the adjusted tableau file will be overwritten.
#' @param maxheight Max height for tableau file, if NULL use system variables.
#' @param maxwidth Max width for tableau file, if NULL use system variables.
#' @param minheight Min height for tableau file, if NULL use system variables.
#' @param minwidth Min width for tableau file, if NULL use system variables.
#'
#' @return tableau file with the correct size.
#' @export
#' @family xml
adjust_tableau_size <- function(import_files, save_location = NULL, maxheight = NULL,
                                maxwidth = NULL, minheight = NULL, minwidth = NULL) {
  if (tools::file_ext(import_files) != "twb") {
    import_files = list.files(import_files, full.names = TRUE)
  }

  for (file in import_files) {
    data <- xml2::read_xml(file)

    # Find the size part
    style_part <- xml2::xml_find_all(data, "//style ")
    size_part <- xml2::xml_find_all(style_part, "//size[@minwidth]")

    ## adjust the size part
    if (is.null(c(maxheight, maxwidth, minheight, minwidth))) {
      minheight <- maxheight <- Sys.getenv("TABLEAU_HEIGHT")
      minwidth <- maxwidth <- Sys.getenv("TABLEAU_WIDTH")
    }
    xml2::xml_set_attrs(size_part, c("maxheight" = maxheight, "maxwidth" = maxwidth,
                                     "minheight" = minheight, "minwidth" = minwidth))
    ## save adjusments
    Ans_1 <-
      readline(prompt = "Do you want to save the adjustments in a new file? y/n: ")
    if (substr(Ans_1, 1, 1) == "y") {
      Ans_2 <-
        readline(prompt = "Yes, so did you give a new save file as input? y/n: ")
      if (substr(Ans_2, 1, 1) == "y") {
        cat("a new save file is given so this file will be used for saving \n")
        # check if the save_location file is .twb
        if (tools::file_ext(save_location) != "twb") {
          stop("save_location file is no .twb file")
        }
        # update and save the new file
        data <- XML::xmlParse(data)
        XML::saveXML(doc = data, file = save_location)
      }
      else {
        stop(
          "stop the process, the user wants his file to be saved at onther file,
           however no new file as input is given."
        )
      }
    }

    else {
      cat("file can be overwritten \n")
      data <- XML::xmlParse(data)
      XML::saveXML(doc = data, file = file)
    }
  }
}
