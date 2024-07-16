#' Make leaflet map of severe storm warnings
#'
#' @param dat_to_map Warnings shapefile read into r (sf object)
#' @param title_string String to display on map title
#'
#' @return Leaflet map
#' @export
#'
plot_map <- function(dat_to_map, title_string) {
  
  # extract bounding box values from shapefile to set map bounds
  bb <- as.list(st_bbox(dat_to_map))
  
  # make base map
  m <- leaflet() |>
    addTiles()
  
  # add layers (1 for each risk category present in forecast)
  for (i in 1:length(dat_to_map$geometry)) {
    m <- addPolygons(
      map = m, 
      data = dat_to_map$geometry[i],
      color = dat_to_map$fill[i],
      label = dat_to_map$LABEL2[i]
    )
  }
  
  # set bounds based on bounding box and add labels
  m <- m |>
    setMaxBounds(lng1 = bb$xmin, lng2 = bb$xmax, lat1 = bb$ymin, lat2 = bb$ymax) |>
    addLegend(labels = dat_to_map$LABEL2, colors = dat_to_map$fill) |>
    leaflet.extras::addResetMapButton() # add button to reset map to original position
  
  
  # make title for map
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
  
  # add title to map
  m <- addControl(map = m, title, position = "topleft", className = "map-title")

  return(m)
  
} # function

