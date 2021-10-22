#!/bin/bash

set -eu

#./build-probe-aws.sh eu-west-3 "17" "17.0.0+35" "zulu" "kernel-4" "jdk"
#

default_bundle="jre"



build_region="$1"
java_major="$2"
java_version="$3"
java_vendor="$4"
kernel=$5
java_bundle_type="${6:-$default_bundle}"


# parameter for bench only, should be removed when kernel 5 will be choosen
[[ $kernel == "kernel-5" ]] && ami="amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"
[[ $kernel == "kernel-4" ]] && ami="amzn2-ami-hvm-2.0.*-x86_64-gp2"

[[ "$java_vendor" != "zulu" ]]&&[[ "$java_bundle_type" != ""  ]]&& echo "java bundle type is ignored for other vendor than Zulu"

copy_regions=$(aws ec2 describe-regions --region=eu-west-3 --query "Regions[?RegionName != '$build_region'].RegionName" --output json | tr -s '[:blank:]' ' ')


packer build \
  -var "region=$build_region" \
  -var "copy_regions=$copy_regions" \
  -var "java_major=$java_major" \
  -var "java_version=$java_version" \
  -var "java_vendor=$java_vendor" \
  -var "java_bundle_type=$java_bundle_type" \
  -var "ami=$ami" \
  -var "kernel_version=$kernel" \
  template-probe-aws.localtest.pkr.hcl
