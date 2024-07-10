#------------------------------------------
# Plot leaflet map

plot_map <- function(dat_to_map, title_string) {
  # extract bounding box values from shapefile to set map bounds
  bb <- as.list(st_bbox(dat_to_map))
  
  # make base map
  m <- leaflet() %>%
    addTiles()
  
  # add layers (1 for each risk category present in forecast)
  for (i in 1:length(dat_to_map$geometry)) {
    m <- addPolygons(
      map = m, data = dat_to_map$geometry[i],
      color = dat_to_map$fill[i],
      label = dat_to_map$LABEL2[i]
    )
  }
  
  m <- m %>%
    setMaxBounds(lng1 = bb$xmin, lng2 = bb$xmax, lat1 = bb$ymin, lat2 = bb$ymax) %>%
    addLegend(labels = dat_to_map$LABEL2, colors = dat_to_map$fill)
  
  
  # --- this section of code to make title for map
  
  tag.map.title <- htmltools::tags$style(HTML("
  .leaflet-control.map-title {
    transform: translate(-50%,20%);
    position: fixed !important;
    left: 20%;
    text-align: center;
    padding-left: 10px;
    padding-right: 10px;
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-size: 15px;
  }
"))
  
  title <- htmltools::tags$div(
    tag.map.title, HTML(paste(
      "SPC Forecast <br>",
      "Issued:", format_datetime_str(dat_to_map$ISSUE[1]), "<br>",
      "Valid:", format_datetime_str(dat_to_map$VALID[1]), "<br> ",
      title_string
    ))
  )
  
  
  m <- addControl(map = m, title, position = "topleft", className = "map-title")
  
  return(m)
} # function

