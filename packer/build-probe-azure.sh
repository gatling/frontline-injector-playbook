#!/bin/bash

set -eu

client_cert_path="$1"
client_id="$2"
java_major="$3"
location="$4"
resource_group="$5"
ssh_private_key_file="$6"
ssh_username="$7"
storage_account="$8"
subscription_id="$9"

adoptopenjdk_url="https://api.adoptopenjdk.net/v2/latestAssets/releases/openjdk${java_major}?openjdk_impl=hotspot&os=linux&arch=x64&release=latest&type=jdk"
java_version=$(curl -Ls "${adoptopenjdk_url}" | jq -r 'map(.version_data.openjdk_version) | .[]')

# Make sure we end up with a valid VHD name
java_version=${java_version//+/_}

# Check if client_id and subscription_id where given as files or strings
if [[ -f "$client_id" ]]; then
  client_id=$(cat "$client_id")
fi
if [[ -f "$subscription_id" ]]; then
  subscription_id=$(cat "$subscription_id")
fi

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
