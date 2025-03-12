#!/bin/bash

# Define color codes
COLORS=('\033[0;31m' '\033[0;32m' '\033[0;33m' '\033[0;34m' '\033[0;35m' '\033[0;36m')
NC='\033[0m' # No Color

# Function to display a message
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


display_message

# Authenticate with Google Cloud
gcloud auth list

# Set project and region
export PROJECT_ID=$(gcloud config get-value project)
export REGION=${ZONE%-*}
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# Download and extract tutorial files
gsutil cp gs://spls/gsp497/gke-monitoring-tutorial.zip .
unzip gke-monitoring-tutorial.zip
cd gke-monitoring-tutorial

# Execute make commands
make create
make validate
make teardown


display_message


echo -e "${COLORS[2]}**************************************************${NC}"
echo -e "${COLORS[3]}**            🎉 CONGRATULATIONS! 🎉            **${NC}"
echo -e "${COLORS[4]}**    YOUR COMMAND EXECUTED SUCCESSFULLY!        **${NC}"
echo -e "${COLORS[2]}**************************************************${NC}"
