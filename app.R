#------------------------------------------
#
# This is a Shiny web application to visualize severe thunderstorm warning levels
# (convective outlooks) from the NOAA Storm Prediction Center.
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



dat1 <- get_data_one_day(whday = 1)
dat2 <- get_data_one_day(whday = 2)
dat3 <- get_data_one_day(whday = 3)


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
      tabPanel("Day 2 Outlook", leaflet::leafletOutput("day2map", width = "100%")),
      tabPanel("Day 3 Outlook", leaflet::leafletOutput("day3map", width = "100%")),
      tabPanel("About", h4("This Shiny App Displays ",
                           a(href = "https://www.spc.noaa.gov/products/outlook/", "Convective Outlooks"), 
                           "from the ", 
                           a(href = "https://www.spc.noaa.gov/", "NOAA Storm Prediction Center"),
                           "on an interactive leaflet map."),
      h4("Disclaimer: This app is not affiliated with or endorsed by NOAA or SPC. Before making any desicions based on these forecasts, users should check the official forecast pages to verify accuracy. ")
      )
    ) #tabsetPanel
  )#sidebarLayout
)#fluidPage


#-------------------------------------------------------------------
# Define server logic for app
#-------------------------------------------------------------------

server <- function(input, output) {
  
  output$day1map <- leaflet::renderLeaflet({
    plot_map(dat1, "Day 1 Outlook")
  })
  # 
  output$day2map <- leaflet::renderLeaflet({
    plot_map(dat2, "Day 2 Outlook")
  })
  # 
  output$day3map <- leaflet::renderLeaflet({
    plot_map(dat3, "Day 3 Outlook")
  })
  # 
  
}



#-------------------------------------------------------------------
# Run the application 
#-------------------------------------------------------------------

shinyApp(ui = ui, server = server)
