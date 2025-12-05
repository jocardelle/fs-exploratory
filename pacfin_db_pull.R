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

# First query 
query <- "
SELECT DISTINCT
    DEALER_ID,
    DEALER_NUM,
    DEALER_NAME
FROM pacfin_marts.comprehensive_ft
WHERE
    PACFIN_YEAR >= 1969 AND PACFIN_YEAR <= 2023
    AND COUNTY_STATE IN ('WA', 'CA', 'OR')
"
# Execute the query
result <- sqlQuery(channel_pacfin, query)
view(result)

# Save out data
write.csv(result, here("data/pacfin/unique_dealers.csv"))


# Second query
query <- "
SELECT
    PACFIN_YEAR,
    COUNTY_CODE,
    COUNTY_NAME,
    IOPAC_PORT_GROUP,
    PACFIN_SPECIES_COMMON_NAME,
    SUM(LANDED_WEIGHT_LBS) AS LANDED_WEIGHT_LBS,
    SUM(ROUND_WEIGHT_LBS) AS ROUND_WEIGHT_LBS,
    SUM(EXVESSEL_REVENUE) AS REVENUE
FROM pacfin_marts.comprehensive_ft
WHERE
    PACFIN_YEAR BETWEEN 1969 AND 2023
    AND COUNTY_STATE IN ('WA', 'CA', 'OR')
GROUP BY
    PACFIN_YEAR,
    COUNTY_CODE,
    COUNTY_NAME,
    IOPAC_PORT_GROUP,
    COUNTY_STATE,
    PACFIN_SPECIES_COMMON_NAME
"

result <- sqlQuery(channel_pacfin, query)
view(result)

write.csv(result, here("data/pacfin/port_species.csv"))

# Third query
query <- "
SELECT
    PACFIN_YEAR,
    DEALER_ID,
    DEALER_NUM,
    DEALER_NAME,
    IOPAC_PORT_GROUP,
    PACFIN_SPECIES_COMMON_NAME,
    SUM(LANDED_WEIGHT_LBS) AS LANDED_WEIGHT_LBS,
    SUM(ROUND_WEIGHT_LBS) AS ROUND_WEIGHT_LBS,
    SUM(EXVESSEL_REVENUE) AS REVENUE
FROM pacfin_marts.comprehensive_ft
WHERE
    PACFIN_YEAR BETWEEN 1969 AND 2023
    AND COUNTY_STATE IN ('WA', 'CA', 'OR')
GROUP BY
    PACFIN_YEAR,
    DEALER_ID,
    DEALER_NUM,
    DEALER_NAME,
    IOPAC_PORT_GROUP,
    PACFIN_SPECIES_COMMON_NAME
"

result <- sqlQuery(channel_pacfin, query)
view(result)

write.csv(result, here("data/pacfin/port_species_dealer.csv"))

# Fourth Query
query <- "
SELECT
    FISH_TICKET_ID,
    LANDED_WEIGHT_LBS,
    PACFIN_SPECIES_COMMON_NAME,
    PACFIN_YEAR,
    DEALER_ID,
    DEALER_NUM,
    DEALER_NAME,
    IOPAC_PORT_GROUP
FROM pacfin_marts.comprehensive_ft
WHERE
    PACFIN_YEAR BETWEEN 2009 AND 2023
    AND COUNTY_STATE IN ('WA', 'CA', 'OR')
"

result <- sqlQuery(channel_pacfin, query)
view(result)

write.csv(result, here("data/pacfin/ftid_dealer_09_23.csv"))

# Fifth Query
query <- "
SELECT
    FISH_TICKET_ID,
    LANDED_WEIGHT_LBS,
    PACFIN_SPECIES_COMMON_NAME,
    PACFIN_YEAR,
    DEALER_ID,
    DEALER_NUM,
    DEALER_NAME,
    IOPAC_PORT_GROUP
FROM pacfin_marts.comprehensive_ft
WHERE
    PACFIN_YEAR BETWEEN 1969 AND 1995
    AND COUNTY_STATE IN ('WA', 'CA', 'OR')
"

result <- sqlQuery(channel_pacfin, query)
view(result)

write.csv(result, here("data/pacfin/ftid_dealer_69_95.csv"))

# Sixth Query
query <- "
SELECT
    FISH_TICKET_ID,
    PORT_NAME,
    COUNTY_CODE,
    COUNTY_NAME,
    COUNTY_STATE
FROM pacfin_marts.comprehensive_ft
WHERE
    PACFIN_YEAR BETWEEN 1995 AND 2008
    AND COUNTY_STATE IN ('WA', 'CA', 'OR')
"

result <- sqlQuery(channel_pacfin, query)
view(result)

write.csv(result, here("data/pacfin/ftid_location_95_08.csv"))

# Seventh query
query <- "
SELECT
    FISH_TICKET_ID,
    PORT_NAME,
    COUNTY_CODE,
    COUNTY_NAME,
    COUNTY_STATE
FROM pacfin_marts.comprehensive_ft
WHERE
    PACFIN_YEAR BETWEEN 2009 AND 2023
    AND COUNTY_STATE IN ('WA', 'CA', 'OR')
"

result <- sqlQuery(channel_pacfin, query)
view(result)

write.csv(result, here("data/pacfin/ftid_location_09_23.csv"))

# Close the connection
odbcClose(channel_pacfin)
