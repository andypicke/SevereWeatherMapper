#------------------------------------------
#
# Shiny web application to visualize severe thunderstorm predictions in
# interactive leaflet map.
#
# Andy Pickering
# 2024/07/10
# andypicke@gmail.com
#
#
#------------------------------------------

library(shiny)
library(sf)
library(leaflet)
source('./R/get_all_links.R')



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


#whday <- 1

dat1 <- get_data_one_day(whday = 1)



#-------------------------------------------------------------------
# Define UI for app
#-------------------------------------------------------------------

ui <- fluidPage(
  
  # Application title
  titlePanel("Convective Outlook Forecast"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(),
    
    # Show a plot of the generated distribution
    tabsetPanel(
      tabPanel("Day 1 Outlook", leaflet::leafletOutput("day1map", width = "100%")),
      #tabPanel("Day 2 Outlook", leaflet::leafletOutput("day2map", width = "100%")),
      #tabPanel("Day 3 Outlook", leaflet::leafletOutput("day3map", width = "100%")),
      tabPanel("About", h3("This Shiny App Displays ",
                           a(href = "https://www.spc.noaa.gov/products/outlook/", "Convective Outlooks"), 
                           "from the ", 
                           a(href = "https://www.spc.noaa.gov/", "NOAA Storm Prediction Center")
      ),
      a(href = "Ahttps://www.spc.noaa.gov/products/outlook/", "link"),
      h5("Disclaimer...This app is not affiliated with or endorsed by NOAA, SPC, etc... Before making any desicions based on these forecasts, users should check the official forecast pages to verify accuracy. ")
      )
    )
  )
)


#-------------------------------------------------------------------
# Define server logic for app
#-------------------------------------------------------------------

server <- function(input, output) {
  
  output$day1map <- leaflet::renderLeaflet({
    plot_map(dat1, "Day 1 Outlook")
  })
  
  # output$day2map <- leaflet::renderLeaflet({
  #   plot_map(dat2, "Day 2 Outlook")
  # })
  # 
  # output$day3map <- leaflet::renderLeaflet({
  #   plot_map(dat3, "Day 3 Outlook")
  # })
  
  
}



#-------------------------------------------------------------------
# Run the application 
#-------------------------------------------------------------------

shinyApp(ui = ui, server = server)
