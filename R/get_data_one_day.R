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
  
  # get filename of shapefile
  shp_fname <- basename(shp_url)
  print(shp_fname)
  
  # base filename (remove *-shp.zip*) to use to load files later
  basefname <- stringr::str_remove(shp_fname, "-shp.zip")
  print(basefname)
  
  
  # destination to save downloaded file to
  dest_file <- file.path(".", "data", shp_fname)
  
  dest_dir <- tempdir()
  dest_file <- tempfile(tmpdir = dest_dir)
  
  # download the zip file containing shapefiles
  download.file(url = shp_url, dest_file)
  
  # unzip the file
  unzip(dest_file, exdir = dest_dir)
  
  # get the file name
  shp_file <- list.files(dest_dir, pattern = "cat.shp$", full.names = TRUE)
  
  # read the shapfile w/ sf
  dat <- st_read(shp_file)
  
}
