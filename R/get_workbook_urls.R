#' Get Workbook URLs
#'
#' This function parses an XML document representing a Tableau workbook and finds all nodes that have a url attribute containing 'views'.
#' It then extracts these URLs and returns them in a data frame.
#'
#' @param wb The path to the Tableau workbook file (.twb).
#'
#' @return A data frame containing the URLs found in the workbook.
#' @export
get_workbook_urls <- function(wb) {
  # Parse the XML document
  doc <- XML::xmlParse(wb)

  # Get the root node
  root <- XML::xmlRoot(doc)

  # Find all nodes that have a url attribute containing 'views'
  nodes <- XML::xpathSApply(root, "//*[contains(@url, 'views')]")

  # Initialize an empty vector to store the URLs
  urls <- character(length(nodes))

  # Loop over the nodes
  for (i in seq_along(nodes)) {
    # Extract the URL attribute
    url <- XML::xmlGetAttr(nodes[[i]], "url")

    # Store the URL in the urls vector
    urls[i] <- url
  }

  # Convert the urls vector to a data frame
  dfUrls <- data.frame(URL = urls)

  return(dfUrls)
}
