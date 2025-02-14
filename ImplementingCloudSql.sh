clear

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

# Set Google Cloud environment variables
export ZONE=$(gcloud compute instances list --project="$DEVSHELL_PROJECT_ID" --format="value(zone)" | head -n 1)
export REGION="${ZONE%-*}"

# Enable Serverless VPC Access
gcloud services enable vpcaccess.googleapis.com --project=$DEVSHELL_PROJECT_ID

# Create VPC Network Peering
gcloud services enable servicenetworking.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud compute addresses create google-managed-services-default \
  --global \
  --purpose=VPC_PEERING \
  --prefix-length=16 \
  --description="peering range for Google-managed services" \
  --network=default \
  --project=$DEVSHELL_PROJECT_ID

gcloud services vpc-peerings connect \
  --service=servicenetworking.googleapis.com \
  --ranges=google-managed-services-default \
  --network=default \
  --project=$DEVSHELL_PROJECT_ID

# Create Cloud SQL Instance for WordPress
gcloud beta sql instances create wordpress-db \
  --region=$REGION \
  --database-version=MYSQL_5_7 \
  --root-password=subscribe_to_quicklab \
  --tier=db-n1-standard-1 \
  --storage-type=SSD \
  --storage-size=10GB \
  --network=default \
  --no-assign-ip \
  --enable-google-private-path \
  --authorized-networks=0.0.0.0/0

# Create WordPress Database
gcloud sql databases create wordpress \
  --instance=wordpress-db \
  --charset=utf8 \
  --collation=utf8_general_ci

# Set up Cloud SQL Proxy on a Compute Instance
gcloud compute ssh --zone "$ZONE" "wordpress-proxy" --project "$DEVSHELL_PROJECT_ID" --quiet --command "
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && chmod +x cloud_sql_proxy
export SQL_CONNECTION=$DEVSHELL_PROJECT_ID:$REGION:wordpress-db
./cloud_sql_proxy -instances=$SQL_CONNECTION=tcp:3306 &
"

# Function to display a random congratulatory message
function random_congrats() {
    MESSAGES=(
        "${GREEN}Congratulations For Completing The Lab! Keep up the great work!${RESET}"
        "${CYAN}Well done! Your hard work and effort have paid off!${RESET}"
        "${YELLOW}Amazing job! You’ve successfully completed the lab!${RESET}"
        "${BLUE}Outstanding! Your dedication has brought you success!${RESET}"
        "${MAGENTA}Great work! You’re one step closer to mastering this!${RESET}"
        "${RED}Fantastic effort! You’ve earned this achievement!${RESET}"
    )

    RANDOM_INDEX=$((RANDOM % ${#MESSAGES[@]}))
    echo -e "${BOLD}${MESSAGES[$RANDOM_INDEX]}"
}

# Display a random congratulatory message
random_congrats

echo -e "\n"
