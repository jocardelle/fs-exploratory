#' Assign County Information to Data Based on ZIP Codes
#'
#' This function takes a data frame, adds county information based on ZIP codes, 
#' and filters the data to only include entries with the highest TOT_RATIO for each 
#' participation code.
#'
#' @param data A data frame containing the survey data. Must include a ZIP code column.
#'
#' @return A data frame with county information and filtered by max TOT_RATIO.
#' 
#' @examples
#' \dontrun{
#'   dat17_with_county <- assign_county(dat17)
#'   dat20_with_county <- assign_county(dat20)
#' }
#' 

library(dplyr)
library(tigris)
library(here)
library(sf)

assign_county <- function(data) {
  
  # Load shapefiles and county crosswalking weights
  HUDcrosswalk <- read.csv(here::here("data", "location_info", "ZIP_COUNTY_032017.csv")) %>% 
    rename(plant_zip = ZIP) %>% 
    select(plant_zip, TOT_RATIO, COUNTY) %>% 
    mutate(
      COUNTY = sprintf("%05d", as.integer(COUNTY)),  # <-- pad to 5 digits
      plant_zip = as.character(plant_zip)
    )
  
  # Best county per ZIP
  HUDcrosswalk_best <- HUDcrosswalk %>%
    group_by(plant_zip) %>%
    slice_max(order_by = TOT_RATIO, n = 1, with_ties = FALSE) %>%
    ungroup()
  
  # County shapefile (with names)
  counties <- tigris::counties(year = 2020, cb = TRUE, class = "sf") %>%
    mutate(COUNTY = paste0(STATEFP, COUNTYFP)) %>%   # make full 5-digit FIPS
    st_drop_geometry() %>%                          
    select(COUNTY, NAME, STATEFP)
  
  # Merge crosswalk with county names
  HUDcrosswalk_best <- HUDcrosswalk_best %>%
    left_join(counties, by = "COUNTY")
  
  # Merge with processor data
  data_with_county <- data %>%
    left_join(HUDcrosswalk_best, by = "plant_zip")
  
  return(data_with_county)
}
