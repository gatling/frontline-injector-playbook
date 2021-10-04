#!/bin/bash

set -eu

build_region="$1"
java_major="$2"
java_version="$3"

copy_regions=$(aws ec2 describe-regions --query "Regions[?RegionName != '$build_region'].RegionName" --output text | tr -s '[:blank:]' ',')

packer build \
  -var "region=$build_region" \
  -var "copy_regions=$copy_regions" \
  -var "java_major=$java_major" \
  -var "java_version=$java_version" \
  template-probe-aws.json
