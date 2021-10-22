#!/bin/bash

set -eu

default_bundle="jre"
java_major="$1"
arch="$2"
bundle_type="${3:-$default_bundle}"


zulu_url="https://api.azul.com/zulu/download/community/v1.0/bundles/?os=linux&jdk_version=${java_major}&arch=${arch}&hw_bitness=64&ext=tar.gz&bundle_type=${bundle_type}&latest=true&javafx=false"

zulu_output=$(curl -Lfs "${zulu_url}")
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Could not reach Zulu API, exiting."
  exit $exit_code
fi

java_version=$(echo "$zulu_output" | jq '.[0].jdk_version | _nwise(3)| join(".")' | jq --slurp | jq 'join("+")' -r)
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Could not find a version field inside Zulu API query"
  exit $exit_code
fi
