#!/bin/bash

set -eu

project="$1"
account_file_location="$2"
build_zone="$3"
java_major="$4"

adoptopenjdk_url="https://api.adoptopenjdk.net/v2/latestAssets/releases/openjdk${java_major}?openjdk_impl=hotspot&os=linux&arch=x64&release=latest&type=jdk"
java_version=$(curl -Ls "${adoptopenjdk_url}" | jq -r 'map(.version_data.openjdk_version) | .[]')

packer build \
  -var "account_file_location=$account_file_location" \
  -var "project=$project" \
  -var "zone=$build_zone" \
  -var "java_major=$java_major" \
  -var "java_version=$java_version" \
  template-probe-gce.json
