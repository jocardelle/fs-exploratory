# 01_pacfin_db_pull.R

# This script runs the SQL pull to retrieve fish ticket data

# Load libraries
library(RODBC)
library(tidyverse)
library(ggplot2)
library(here)

# Prompt password
pswd <- readline("Input Password: ")

# Create a connection to the database called "channel"
channel_pacfin <- odbcConnect("PACFIN", uid = "JCARDELLE", pwd = pswd)

# Hide password again
rm(pswd)

# Get list of tables in the database
table_list <- sqlTables(channel_pacfin)
column_query2 <- sqlQuery(channel_pacfin, "SELECT column_name FROM all_tab_columns WHERE table_name = 'COMPREHENSIVE_REC_EFFORT_EST'")

# What are the names of the columns?
column_query <- sqlQuery(channel_pacfin, "SELECT column_name FROM all_tab_columns WHERE table_name = 'COMPREHENSIVE_FT'")
print(column_query$column_name)

# Query and save temporal revenue data ----
query <- "
SELECT
    PACFIN_YEAR,
    TO_CHAR(LANDING_DATE, 'IW') AS WEEK_NUMBER,
    TO_CHAR(LANDING_DATE, 'MM') AS MONTH_NUMBER,
    TO_CHAR(LANDING_DATE, 'Q') AS QUARTER_NUMBER,
    MANAGEMENT_GROUP_CODE,
    SUM(EXVESSEL_REVENUE) AS TOTAL_EXVESSEL_REVENUE,
    SUM(LANDED_WEIGHT_MTONS) AS TOTAL_LANDED_WEIGHT_MTONS
FROM
    pacfin_marts.comprehensive_ft
WHERE
    PACFIN_YEAR >= 1981 AND PACFIN_YEAR <= 2022
GROUP BY
    PACFIN_YEAR,
    TO_CHAR(LANDING_DATE, 'IW'),
    TO_CHAR(LANDING_DATE, 'MM'),
    TO_CHAR(LANDING_DATE, 'Q'),
    MANAGEMENT_GROUP_CODE
"
# Execute the query
result <- sqlQuery(channel_pacfin, query)

# Save out data
write.csv(result, here("data", "temporal_diversity.csv"))

# Query and save spatial revenue data ----
query <- "
SELECT 
  PACFIN_YEAR,
  EXTRACT(MONTH FROM LANDING_DATE) AS MONTH,
  PACFIN_SPECIES_CODE, 
  MANAGEMENT_GROUP_CODE, 
  PORT_CODE, 
  PACFIN_PORT_CODE,
  SUM(EXVESSEL_REVENUE) AS TOTAL_EXVESSEL_REVENUE,
  SUM(LANDED_WEIGHT_MTONS) AS TOTAL_LANDED_WEIGHT_MTONS
FROM 
  pacfin_marts.comprehensive_ft
WHERE 
  PACFIN_YEAR >= 2020 AND PACFIN_YEAR <= 2022
  AND EXVESSEL_REVENUE IS NOT NULL
  AND LANDED_WEIGHT_MTONS IS NOT NULL
GROUP BY 
  PACFIN_YEAR,
  EXTRACT(MONTH FROM LANDING_DATE),
  PACFIN_SPECIES_CODE, 
  MANAGEMENT_GROUP_CODE, 
  PORT_CODE, 
  PACFIN_PORT_CODE
"
# Execute the query
result_spatial <- sqlQuery(channel_pacfin, query)

# Save out data
saveRDS(result_spatial, here("data", "pacfin_tables_monthly.RDS"))

# When finished, it's a good idea to close the connection
odbcClose(channel_pacfin)
