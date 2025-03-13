#!/bin/bash

# Define text colors
TEXT_COLORS=($(tput setaf 0) $(tput setaf 1) $(tput setaf 2) $(tput setaf 3) $(tput setaf 4) $(tput setaf 5) $(tput setaf 6) $(tput setaf 7))
BG_COLORS=($(tput setab 0) $(tput setab 1) $(tput setab 2) $(tput setab 3) $(tput setab 4) $(tput setab 5) $(tput setab 6) $(tput setab 7))

BOLD=$(tput bold)
RESET=$(tput sgr0)

# Pick random colors
RANDOM_TEXT_COLOR=${TEXT_COLORS[$RANDOM % ${#TEXT_COLORS[@]}]}
RANDOM_BG_COLOR=${BG_COLORS[$RANDOM % ${#BG_COLORS[@]}]}

# Display Welcome Banner
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}######################################################################${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}#                                                                    #${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}#             WELCOME TO EDUTECH BARSHA                              #${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}#                                                                    #${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}######################################################################${RESET}"

# Start Execution
EXEC_COLOR=${TEXT_COLORS[$RANDOM % ${#TEXT_COLORS[@]}]}
echo "${EXEC_COLOR}${BOLD}Starting Execution...${RESET}"

# Create Reports Dataset
bq mk Reports

# Run BigQuery Query
bq query \
  --use_legacy_sql=false \
  --destination_table=$DEVSHELL_PROJECT_ID:Reports.Trees \
  --replace=false \
  --nouse_cache \
  "SELECT
    TIMESTAMP_TRUNC(plant_date, MONTH) as plant_month,
    COUNT(tree_id) AS total_trees,
    species,
    care_taker,
    address,
    site_info
  FROM
    \`bigquery-public-data.san_francisco_trees.street_trees\`
  WHERE
    address IS NOT NULL
    AND plant_date >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 365 DAY)
    AND plant_date < TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY)
  GROUP BY
    plant_month,
    species,
    care_taker,
    address,
    site_info"

# Pick another random color for the final message
FINAL_TEXT_COLOR=${TEXT_COLORS[$RANDOM % ${#TEXT_COLORS[@]}]}
FINAL_BG_COLOR=${BG_COLORS[$RANDOM % ${#BG_COLORS[@]}]}

# Display Congratulations Message
echo "${FINAL_BG_COLOR}${FINAL_TEXT_COLOR}${BOLD}######################################################################${RESET}"
echo "${FINAL_BG_COLOR}${FINAL_TEXT_COLOR}${BOLD}#                                                                    #${RESET}"
echo "${FINAL_BG_COLOR}${FINAL_TEXT_COLOR}${BOLD}#       🎉🎉 CONGRATULATIONS FOR COMPLETING THE LAB! 🎉🎉        #${RESET}"
echo "${FINAL_BG_COLOR}${FINAL_TEXT_COLOR}${BOLD}#                                                                    #${RESET}"
echo "${FINAL_BG_COLOR}${FINAL_TEXT_COLOR}${BOLD}######################################################################${RESET}"

# Subscribe message with random colors
SUBSCRIBE_TEXT_COLOR=${TEXT_COLORS[$RANDOM % ${#TEXT_COLORS[@]}]}
SUBSCRIBE_BG_COLOR=${BG_COLORS[$RANDOM % ${#BG_COLORS[@]}]}

echo "${SUBSCRIBE_BG_COLOR}${SUBSCRIBE_TEXT_COLOR}${BOLD}📢 SUBSCRIBE TO OUR CHANNEL: https://www.youtube.com/@edutechbarsha ${RESET}"
