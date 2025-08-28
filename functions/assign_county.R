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

assign_county <- function(data) {

  # Load shapefiles and county crosswalking weights
  HUDcrosswalk <- read.csv(here::here("data", "raw", "ZIP_COUNTY_032017.csv")) %>% 
    rename(Q5 = ZIP) %>% 
    dplyr::select(Q5, TOT_RATIO, COUNTY) %>% 
    dplyr::mutate(COUNTY = as.numeric(COUNTY))
  
  # Load shapefiles for all U.S. counties
  counties <- tigris::counties(year = 2020, cb = TRUE, class = "sf")
  
  # Filter HUDcrosswalk based on zip codes in the data
  HUDcrosswalk_filtered <- subset(HUDcrosswalk, Q5 %in% data$Q5)
  
  # Merge data with filtered HUDcrosswalk
  data_merged <- merge(data, HUDcrosswalk_filtered, by = "Q5")
  
  # Filter by max TOT_RATIO
  data_filtered <- data_merged %>% 
    dplyr::group_by(PARTICIPATION_CODE) %>% 
    dplyr::filter(TOT_RATIO == max(TOT_RATIO)) %>% 
    dplyr::ungroup()
  
  return(data_filtered)
}
