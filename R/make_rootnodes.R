#' make_rootnodes
#'
#' @param wb The path to the tableau workbook file [.twb].
#'
#' @return The rootnodes.
#' @export
#'
#' @family xml
make_rootnodes <- function(wb) {
  tempd <- tempdir()
  fext <- paste0(".", sub(".*\\.", "", wb))
  tmpf <- tempfile(tmpdir = tempd, fileext = fext)
  file.copy(wb, tmpf)
  filed <- sub(pattern = fext, ".xml", tmpf)
  file.rename(tmpf, filed)
  rootnode <- XML::xmlRoot(XML::xmlParse(file = filed))
  unlink("tempd", recursive = TRUE)
  return(rootnode)
}
