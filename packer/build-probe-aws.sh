#!/bin/bash

set -eu

profile="$1"
build_region="$2"
java_major="$3"

copy_regions=$(aws --profile "$profile" ec2 describe-regions --query "Regions[?RegionName != '$build_region'].RegionName" --output text | tr -s '[:blank:]' ',')

adoptopenjdk_url="https://api.adoptopenjdk.net/v2/latestAssets/releases/openjdk${java_major}?openjdk_impl=hotspot&os=linux&arch=x64&release=latest&type=jdk"
java_version=$(curl -Ls "${adoptopenjdk_url}" | jq -r 'map(.version_data.openjdk_version) | .[]')

packer build \
  -var "profile=$profile" \
  -var "region=$build_region" \
  -var "copy_regions=$copy_regions" \
  -var "java_major=$java_major" \
  -var "java_version=$java_version" \
  template-probe-aws.json
