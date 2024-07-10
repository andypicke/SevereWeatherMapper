
# Function to format date-time strings for forecast issued and valid fields
format_datetime_str <- function(raw_str) {
  if (nchar(raw_str) != 12) {
    warning("datetime string is not correct length")
  }
  raw_date <- substr(raw_str, 1, 8)
  raw_time <- substr(raw_str, 9, nchar(raw_str))
  date_formatted <- paste(substr(raw_date, 1, 4), substr(raw_date, 5, 6), substr(raw_date, 7, 8), sep = "-")
  str_formatted <- paste(date_formatted, raw_time)
  
  return(str_formatted)
}
