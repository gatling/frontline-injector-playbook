#!/bin/bash

set -eu

java_major="$1"
java_version="$2"

location=westeurope
resource_group=GatlingFrontLineInjectorsRG
ssh_username=azure-user
storage_account=injectorsst

# Make sure we end up with a valid VHD name
java_version=${java_version//+/_}

packer build \
  -var "client_id=$CLIENT_ID" \
  -var "client_secret=$CLIENT_SECRET" \
  -var "java_major=$java_major" \
  -var "java_version=$java_version" \
  -var "location=$location" \
  -var "resource_group=$resource_group" \
  -var "ssh_private_key_file=$SSH_PRIVATE_KEY_FILE" \
  -var "ssh_username=$ssh_username" \
  -var "storage_account=$storage_account" \
  -var "subscription_id=$SUBSCRIPTION_ID" \
  template-probe-azure.json
