#' adjust_tableau_font_style
#'
#' Adjust the font style of a tableau file
#'
#' @param import_files selected tableau file or folder, to change its font style. If
#'  it is only a file, make sure it is a twb file.
#' @param font_style the name of the font style you want to use (in quotation marks "")
#' @param save_location The location to which the adjusted tableau file will be
#' saved (this needs to be a .twb file). If empty, the adjusted tableau file will be overwritten.
#'
#' @return tableau file with the correct font style.
#' @export
#'
adjust_tableau_font_style <- function (import_files, font_style = "Tableau Regular", save_location = NULL)
{
  # if the path gives a whole map instead of one file, make a file list.
  if (tools::file_ext(import_files) != "twb") {
    import_files = list.files(import_files, full.names = TRUE)
  }

  for (file in import_files) {
    #read xml file('s)
    data <- xml2::read_xml(file)

    # Find the font-style part
    style_part <- xml2::xml_find_all(data, "//formatted-text//run")

    for (type_section in style_part) {
      # change the style
      xml2::xml_set_attr(type_section, "fontname", font_style)
    }

    Ans_1 <- readline(prompt = "Do you want to save the adjustments in a new file? y/n: ")

    if (substr(Ans_1, 1, 1) == "y") {
      Ans_2 <- readline(prompt = "Yes, so did you give a new save file as input? y/n: ")
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
        stop("stop the process, the user wants his file to be saved at onther file,
               however no new file as input is given.")
      }
    }

    else {
      cat("file can be overwritten \n")

      data <- XML::xmlParse(data)
      XML::saveXML(doc = data, file = file)

    }
  }
}
