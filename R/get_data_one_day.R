#' Download and read into R shapefile for Convective outlook from NOAA Storm Prediction Center
#'
#' @param whday Day of outlook (ex 1 = Day 1 Outlook)
#'
#' @return 
#' @export
#'
#' @examples outlook <- get_data_one_day(whday = 1)
get_data_one_day <- function(whday){
  
  
  # Base url for the spc site that has the outlooks
  base_url <- "https://www.spc.noaa.gov"
  
  # get list of all links on the spc page for
  links <- get_all_links(page_url = paste0(base_url, "/products/outlook/day", whday, "otlk.html"))
  
  # find the link for the shapefile (the only one that ends in 'shp.zip')
  shp_link <- links[which(stringr::str_ends(links, "shp.zip"))]
  
  # complete url to download shapefile(s) (zip file) from website
  shp_url <- paste0(base_url, shp_link)
  
  glue::glue('The latest day{whday} shapefile as of {Sys.time()} is {shp_url}')
  
  # create a temporary folder and filename to download the zip file (need to do this for deploying shiny app)
  dest_dir <- tempdir()
  dest_file <- tempfile(tmpdir = dest_dir)
  
  # remove any shpfiles already in temp dir from this session
  do.call(file.remove, list(list.files(dest_dir, pattern = "*otlk*", full.names = TRUE)))
  
  # download the zip file containing shapefiles
  download.file(url = shp_url, destfile = dest_file)
  
  # unzip the file
  unzip(dest_file, exdir = dest_dir)
  
  # get the file name we want
  shp_file <- list.files(dest_dir, pattern = "*cat.shp$", full.names = TRUE)
  
  # read the shapefile into R w/ sf
  dat <- sf::st_read(shp_file)
  
}
