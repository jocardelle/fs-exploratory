# U.S. West Coast Seafood Processors

## About

This repository explores historical and current patterns in U.S. West Coast fish processing, fish landings, and community-level dependence on these. The project aims to understand how commercial fishing communities, including processing communities, may be ipacted by climate-driven shifts in marine resources.

### Project Goals

-   Examine historic community-level measures of commercial fishing engagement and reliance.
-   Examine historic community-level measures of processor engagement (employment, products, revenue, etc.).
-   Identify how fishing communities and processors may experience impacts form shifts in marine resources.

### Scripts

-   `data_cleaning.qmd` - Prepares and cleans the Processed Products data for use in exploratory and comparative analyses
-   `process-products-eda.qmd` - Initial exploratory data analysis of the Processed Products data.
-   `fish-ticket-pp-comparison.qmd` - Compares PacFIN fish ticket landings to processor-reported products, including regional species level poundage differences.
-   `ft-edc-pp-matching.qmd` - Matches processor/dealers from pacFIN, EDC, and Processed Products.
-   `pacfin_db_pull.R` - Pulls Pacfin Comprehensive_FT data
-   `processing_landing_locations.qmd` - Examines how the locations where fish are landed compare to the locations where they are processed and how those relationships change over time.
-   `imports-exports.qmd` - Looks at imports/exports, landing, and processing of single species.
-   `functions/assign_county_sf.R`- Loads county shapefiles, merges them with provided data, and transforms CRS
-   `functions/assign_county.R` - Adds county information to data frames using ZIP codes

## Repository Structure

```         
|── fs-exporatory
|└── README.md
|└── functions/
|  └── assign_county_sf.R
|  └── assign_county.R
|└── data_cleaning.qmd  
|└── processed-products-eda.qmd
|└── fish-ticket-pp-comparison.qmd 
|└── ft-edc-pp-matching.qmd
|└── processing_landing_locations.qmd
|└── imports-exports.qmd 
|└── pacfin_db_pull.R  
```

## Data

All datasets used in this project are confidential and therefore not included in the repository. Below is a summary of the referenced datasets.

### Processed Products (1969–2023)

Source: [NOAA Fisheries Commercial Fisheries Data System](https://www.fisheries.noaa.gov/inport/item/20758)

This annual survey provides a national dataset on U.S. seafood processing. It includes employment, wholesale value, and product information for US seafood processors.

### PacFIN Fish Ticket Data (1981–2023)

Source: [Pacific Fisheries Information Network](https://pacfin.psmfc.org/)

The Comprehensive_FT table integrates all shoreside landings on the U.S. West Coast with enhanced federal and state information.

### West Coast Groundfish EDC (2009–2023)

Source: [NOAA Fisheries Economic Data Collection Program](https://www.fisheries.noaa.gov/west-coast/science-data/economic-data-collection-west-coast-groundfish-trawl-fishery)

Collects annual economic information from vessels, first receivers, processors, and quota share owners involved in the West Coast Groundfish Trawl Catch Share Program.

## Acknowledgments

This work is part of the [Future Seas III](https://cpo.noaa.gov/funded_projects/future-seas-iii-ensuring-resilience-and-adaptive-capacity-of-california-current-system-fisheries-under-climate-driven-ecosystem-shifts/) project.