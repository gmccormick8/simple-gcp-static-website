#!/bin/bash
# This script sets up the environment for Cloud Shell and applies the Terraform script.
#usage: bash setup.sh

set -e
echo "Setting up the environment..."
echo 'project_id = "'$DEVSHELL_PROJECT_ID'"' > terraform.tfvars

api_array=(
  "compute.googleapis.com"
  "storage-api.googleapis.com"
)

for api in "${api_array[@]}";
do
  echo "Enabling API: $api"
  gcloud services enable "$api" --project="$DEVSHELL_PROJECT_ID"
done

# Check the Terraform version and updates if needed. Based on jacouh'script https://stackoverflow.com/questions/48491662/comparing-two-version-numbers-in-a-shell-script
version=$(terraform -v | grep -Eo -m 1 '[0-9]+\.[0-9]+\.[0-9]+')
expected_version=1.11.0

xarr=(${version//./ })
yarr=(${expected_version//./ })

current=true
for i in "${!xarr[@]}"; do
 if [ ${xarr[i]} -ge ${yarr[i]} ]; then
    current=true
  elif [ ${xarr[i]} -lt ${yarr[i]} ]; then
    current=false
    break
  fi
done

if [[ $current == false ]]; then
  read -p "Terraform version is less than 1.11.0. Do you want to update it? (y/n) " update_response
  if [[ "$update_response" != "y" ]]; then
    echo "Exiting without updating Terraform."
    exit 0
  else
    echo "Updating Terraform..."
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
    if [ $? -ne 0 ]; then
      echo "Error during Terraform update. Exiting..."
      exit 1
    fi
    echo "Terraform updated successfully."
  fi
fi
