#!/bin/bash

# Define color codes
COLORS=('\033[0;31m' '\033[0;32m' '\033[0;33m' '\033[0;34m' '\033[0;35m' '\033[0;36m')
NC='\033[0m' # No Color

# Function to display a message with auto-changing colors
display_message() {
    local index=0
    local pattern=(
        "**********************************************************"
        "**                 S U B S C R I B E  TO                **"
        "**                 EDUTECH BARSHA                       **"
        "**                                                      **"
        "**********************************************************"
    )
    for line in "${pattern[@]}"
    do
        echo -e "${COLORS[$index]}${line}${NC}"
        ((index=(index+1) % ${#COLORS[@]})) # Change color for next line
    done
}

# Display subscription message before execution
display_message

# Run BigQuery queries
bq query --use_legacy_sql=false \
"
SELECT
  name, gender,
  SUM(number) AS total
FROM
  \`bigquery-public-data.usa_names.usa_1910_2013\`
GROUP BY
  name, gender
ORDER BY
  total DESC
LIMIT
  10
"

bq mk babynames

bq mk --table \
  --schema "name:string,count:integer,gender:string" \
  $DEVSHELL_PROJECT_ID:babynames.names_2014

bq query --use_legacy_sql=false \
"
SELECT
 name, count
FROM
 \`babynames.names_2014\`
WHERE
 gender = 'M'
ORDER BY count DESC LIMIT 5
"

# Display subscription message after execution
display_message

# Display Congratulations message with color
echo -e "${COLORS[2]}**************************************************${NC}"
echo -e "${COLORS[3]}**            🎉 CONGRATULATIONS! 🎉            **${NC}"
echo -e "${COLORS[4]}**       YOUR COMMAND EXECUTED SUCCESSFULLY!     **${NC}"
echo -e "${COLORS[2]}**************************************************${NC}"
