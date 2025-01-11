#!/bin/bash

# Define color variables
BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`

# Array of color codes excluding black and white
TEXT_COLORS=($RED $GREEN $YELLOW $BLUE $MAGENTA $CYAN)
BG_COLORS=($BG_RED $BG_GREEN $BG_YELLOW $BG_BLUE $BG_MAGENTA $BG_CYAN)

# Pick random colors
RANDOM_TEXT_COLOR=${TEXT_COLORS[$RANDOM % ${#TEXT_COLORS[@]}]}
RANDOM_BG_COLOR=${BG_COLORS[$RANDOM % ${#BG_COLORS[@]}]}

# Display Welcome Banner
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}######################################################################${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}#                                                                    #${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}#             WELCOME TO EDUTECH BARSHA                              #${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}#                                                                    #${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}######################################################################${RESET}"
echo

#----------------------------------------------------start--------------------------------------------------#

echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}Starting Execution!!${RESET}"

# Cloud Resource Connection setup
echo "${BLUE}${BOLD}Step 1: Creating a Cloud Resource Connection${RESET}"
bq mk --connection --location=US --project_id=$DEVSHELL_PROJECT_ID --connection_type=CLOUD_RESOURCE gemini_conn

# Export Service Account ID
echo "${GREEN}${BOLD}Step 2: Exporting Service Account ID${RESET}"
export SERVICE_ACCOUNT=$(bq show --format=json --connection $DEVSHELL_PROJECT_ID.US.gemini_conn | jq -r '.cloudResource.serviceAccountId')

# IAM Policy Binding
echo "${YELLOW}${BOLD}Step 3: Adding IAM Policy Binding to Project${RESET}"
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT \
    --role="roles/aiplatform.user"

echo "${MAGENTA}${BOLD}Step 4: Adding IAM Policy Binding to GCS Bucket${RESET}"
gcloud storage buckets add-iam-policy-binding gs://$DEVSHELL_PROJECT_ID-bucket \
    --member="serviceAccount:$SERVICE_ACCOUNT" \
    --role="roles/storage.objectAdmin"

# BigQuery Dataset creation
echo "${CYAN}${BOLD}Step 5: Creating BigQuery Dataset${RESET}"
bq mk gemini_demo

# Load and Process Data
echo "${RED}${BOLD}Step 6: Loading Customer Reviews Data and Executing Steps${RESET}"
# (Include commands for loading and querying data as in your code)

# Display congratulatory message
echo
function random_congrats() {
    MESSAGES=(
        "${GREEN}Congratulations For Completing The Lab!${RESET}"
        "${CYAN}Amazing effort! Your hard work is evident!${RESET}"
    )
    echo -e "${BOLD}${MESSAGES[RANDOM % ${#MESSAGES[@]}]}"
}
random_congrats

# Cleanup
echo "${RED}${BOLD}Cleaning up temporary files...${RESET}"
remove_files() {
    for file in *; do
        if [[ "$file" == gsp* || "$file" == arc* || "$file" == shell* ]]; then
            if [[ -f "$file" ]]; then
                rm "$file"
                echo "File removed: $file"
            fi
        fi
    done
}
remove_files
clear
