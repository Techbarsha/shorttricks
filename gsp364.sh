#!/bin/bash

# Define color variables
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'

NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

# Pick random colors
RANDOM_TEXT_COLOR=${TEXT_COLORS[$RANDOM % ${#TEXT_COLORS[@]}]}
RANDOM_BG_COLOR=${BG_COLORS[$RANDOM % ${#BG_COLORS[@]}]}

# Display Welcome Banner
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}######################################################################${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}#                                                                    #${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}#             WELCOME TO EDUTECH BARSHA                              #${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}#                                                                    #${RESET}"
echo "${RANDOM_BG_COLOR}${RANDOM_TEXT_COLOR}${BOLD}######################################################################${RESET}"

# Clear the screen
clear

# Start Execution
echo "${BLUE_TEXT}${BOLD_TEXT}=======================================${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}         Starting Execution...         ${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}=======================================${RESET_FORMAT}"
echo

# Instructions before setting the zone
echo "${CYAN_TEXT}${BOLD_TEXT}Step 1:${RESET_FORMAT} Fetching the default compute zone for the project."
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

# Instructions before creating the cluster
echo "${CYAN_TEXT}${BOLD_TEXT}Step 2:${RESET_FORMAT} Creating a GKE cluster named 'gmp-cluster' with 3 nodes."
echo "${YELLOW_TEXT}${BOLD_TEXT}This may take a few minutes. Please wait...${RESET_FORMAT}"
gcloud container clusters create gmp-cluster --num-nodes=3 --zone=$ZONE

# Instructions before getting cluster credentials
echo "${CYAN_TEXT}${BOLD_TEXT}Step 3:${RESET_FORMAT} Fetching credentials for the 'gmp-cluster'."
echo "${YELLOW_TEXT}${BOLD_TEXT}This will allow kubectl to interact with the cluster.${RESET_FORMAT}"
gcloud container clusters get-credentials gmp-cluster --zone=$ZONE

# Instructions before creating namespace
echo "${CYAN_TEXT}${BOLD_TEXT}Step 4:${RESET_FORMAT} Creating a namespace 'gmp-test' for Prometheus setup."
kubectl create ns gmp-test

# Instructions before applying Prometheus setup
echo "${CYAN_TEXT}${BOLD_TEXT}Step 5:${RESET_FORMAT} Applying Prometheus setup manifests."
echo "${YELLOW_TEXT}${BOLD_TEXT}Downloading and applying setup.yaml...${RESET_FORMAT}"
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/manifests/setup.yaml

echo "${YELLOW_TEXT}${BOLD_TEXT}Downloading and applying operator.yaml...${RESET_FORMAT}"
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/manifests/operator.yaml

echo "${YELLOW_TEXT}${BOLD_TEXT}Downloading and applying example-app.yaml...${RESET_FORMAT}"
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/examples/example-app.yaml

# Instructions before creating the OperatorConfig file
echo "${CYAN_TEXT}${BOLD_TEXT}Step 6:${RESET_FORMAT} Creating the OperatorConfig file 'op-config.yaml'."
echo "${YELLOW_TEXT}${BOLD_TEXT}This file configures Prometheus to collect specific metrics.${RESET_FORMAT}"
cat > op-config.yaml <<'EOF_END'
apiVersion: monitoring.googleapis.com/v1alpha1
collection:
  filter:
    matchOneOf:
    - '{job="prom-example"}'
    - '{__name__=~"job:.+"}'
kind: OperatorConfig
metadata:
  annotations:
    components.gke.io/layer: addon
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"monitoring.googleapis.com/v1alpha1","kind":"OperatorConfig","metadata":{"annotations":{"components.gke.io/layer":"addon"},"labels":{"addonmanager.kubernetes.io/mode":"Reconcile"},"name":"config","namespace":"gmp-public"}}
  creationTimestamp: "2022-03-14T22:34:23Z"
  generation: 1
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
  name: config
  namespace: gmp-public
  resourceVersion: "2882"
  uid: 4ad23359-efeb-42bb-b689-045bd704f295
EOF_END

# Instructions before creating the GCS bucket
echo "${CYAN_TEXT}${BOLD_TEXT}Step 7:${RESET_FORMAT} Creating a Google Cloud Storage bucket."
echo "${YELLOW_TEXT}${BOLD_TEXT}The bucket will be named after your project ID.${RESET_FORMAT}"
export PROJECT=$(gcloud config get-value project)
gsutil mb -p $PROJECT gs://$PROJECT

# Instructions before uploading the config file
echo "${CYAN_TEXT}${BOLD_TEXT}Step 8:${RESET_FORMAT} Uploading 'op-config.yaml' to the GCS bucket."
gsutil cp op-config.yaml gs://$PROJECT

# Instructions before setting ACLs
echo "${CYAN_TEXT}${BOLD_TEXT}Step 9:${RESET_FORMAT} Setting public-read access to the GCS bucket."
echo "${YELLOW_TEXT}${BOLD_TEXT}This will make the contents of the bucket publicly accessible.${RESET_FORMAT}"
gsutil -m acl set -R -a public-read gs://$PROJECT

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
