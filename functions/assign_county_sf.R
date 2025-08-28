#' Make Shapefiles and Merge with Data
#' 
#' This function loads county shapefiles, merges them with the provided data,
#' and transforms the Coordinate Reference System (CRS).
#' 
#' @param agg_data A data frame that contains county-level aggregated data. Must include a 'COUNTY' column.
#' 
#' @return A transformed data frame with shapefiles and CRS applied.
#' 
#' @importFrom dplyr filter mutate left_join
#' @importFrom sf st_as_sf st_transform
#' @importFrom tigris counties
#' 
#' @examples
#' \dontrun{
#' agg17 <- data.frame(COUNTY = c(53001, 53003), value = c(10, 20))
#' transformed_data <- make_shapefiles(agg17)
#' }
#' 

assign_county_sf <- function(agg_data) {
  
  # Load counties using tigris
  counties <- counties(cb = TRUE, resolution = "5m", year = 2018) %>%
    st_as_sf() %>%
    filter(STATEFP == "53" | STATEFP == "41" | STATEFP == "06") %>% 
    mutate(GEOID = as.numeric(GEOID))
  
  # Merge with input data
  agg_data_merged <- counties %>% 
    rename(COUNTY = GEOID) %>% 
    left_join(agg_data, by = "COUNTY")
  
  # Set CRS
  agg_data_transformed <- st_transform(agg_data_merged, crs = 4326)
  
  agg_data_transformed = agg_data_transformed %>% 
    select(-c('COUNTYNS', 'COUNTYFP', 'AFFGEOID', 'LSAD', 'ALAND', 'AWATER'))
  
  return(agg_data_transformed)
}

