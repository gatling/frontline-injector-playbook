#!/bin/bash

set -eu

client_cert_path="$1"
java_major="$2"
location="$3"
resource_group="$4"
ssh_private_key_file="$5"
ssh_username="$6"
storage_account="$7"

adoptopenjdk_url="https://api.adoptopenjdk.net/v2/latestAssets/releases/openjdk${java_major}?openjdk_impl=hotspot&os=linux&arch=x64&release=latest&type=jdk"
java_version=$(curl -Ls "${adoptopenjdk_url}" | jq -r 'map(.version_data.openjdk_version) | .[]')

# Make sure we end up with a valid VHD name
java_version=${java_version//+/_}

subscription_id=$(az account show --query "id" --output tsv)
client_id=$(az ad app list --query "[?displayName=='Packer'].appId" --output tsv)

packer build \
  -var "client_id=$client_id" \
  -var "client_cert_path=$client_cert_path" \
  -var "java_major=$java_major" \
  -var "java_version=$java_version" \
  -var "location=$location" \
  -var "resource_group=$resource_group" \
  -var "ssh_private_key_file=$ssh_private_key_file" \
  -var "ssh_username=$ssh_username" \
  -var "storage_account=$storage_account" \
  -var "subscription_id=$subscription_id" \
  template-probe-azure.json
