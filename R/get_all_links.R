
# Define a function to make a list of all links on a webpage
get_all_links <- function(page_url) {
  # read the html from the website for day 1 outlook
  html <- rvest::read_html(page_url)
  
  # create a list of all the hyperlinks on the website
  links <- rvest::html_attr(rvest::html_nodes(html, "a"), "href")
}