#!/bin/bash

# Define color variables
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m' 

# Function to print a banner with color cycling
print_banner() {
    local colors=("$YELLOW" "$CYAN" "$GREEN")
    local i=0
    for line in "$@"; do
        echo -e "${colors[i % ${#colors[@]}]}$line${NC}"
        ((i++))
    done
}

# Welcome banner
welcome_banner=(
"**********************************************************"
"**                 WELCOME  TO                          **"
"**                 EDUTECH BARSHA                       **"
"**                                                      **"
"**********************************************************"
)
print_banner "${welcome_banner[@]}"

# First query: Fetches 10 rows from Citi Bike stations data
bq query --use_legacy_sql=false "
SELECT
  *
FROM
  \`bigquery-public-data.new_york_citibike.citibike_stations\`
LIMIT
  10
"

# Second query: Finds Citi Bike stations with > 30 bikes
bq query --use_legacy_sql=false "
SELECT
  ST_GeogPoint(longitude, latitude) AS WKT,
  num_bikes_available
FROM
  \`bigquery-public-data.new_york.citibike_stations\`
WHERE num_bikes_available > 30
"

# Third query: Same as the second, repeated
bq query --use_legacy_sql=false "
SELECT
  ST_GeogPoint(longitude, latitude) AS WKT,
  num_bikes_available
FROM
  \`bigquery-public-data.new_york.citibike_stations\`
WHERE num_bikes_available > 30
"

# Subscription banner
subscribe_banner=(
"**********************************************************"
"**                 S U B S C R I B E  TO               **"
"**                 EDUTECH BARSHA                       **"
"**                                                      **"
"**********************************************************"
)
print_banner "${subscribe_banner[@]}"

# Final congratulations message
echo -e "${GREEN}*************************************************${NC}"
echo -e "${CYAN}**       CONGRATULATIONS! QUERY COMPLETED       **${NC}"
echo -e "${GREEN}*************************************************${NC}"
