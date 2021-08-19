#!/bin/bash

set -eu

profile="$1"
build_region="$2"
java_major="$3"

copy_regions=$(aws --profile "$profile" ec2 describe-regions --query "Regions[?RegionName != '$build_region'].RegionName" --output text | tr -s '[:blank:]' ',')

adoptopenjdk_url="https://api.adoptium.net/v3/assets/latest/${java_major}/hotspot"
java_version=$(curl -Ls "${adoptopenjdk_url}" | jq -r '.[] | select(
    (.binary.os == "linux") and
    (.binary.architecture == "x64") and
    (.binary.image_type == "jdk")
  ) | .version.openjdk_version')

packer build \
  -var "profile=$profile" \
  -var "region=$build_region" \
  -var "copy_regions=$copy_regions" \
  -var "java_major=$java_major" \
  -var "java_version=$java_version" \
  template-probe-aws.json
