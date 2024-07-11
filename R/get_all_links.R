#'  Return a list of all links on a webpage
#'
#' @param page_url URL of the webpage
#'
#' @return links: a list of all hyperlinks on page
#' @export
#'
get_all_links <- function(page_url) {
  
  # read the html from the website 
  html <- rvest::read_html(page_url)
  
  # create a list of all the hyperlinks on the website
  links <- rvest::html_attr(rvest::html_nodes(html, "a"), "href")
}