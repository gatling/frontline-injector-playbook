#!/bin/bash

set -u

java_major="$1"

adoptopenjdk_url="https://api.adoptium.net/v3/assets/latest/${java_major}/hotspot"

adoptopenjdk_output=$(curl -Lfs "${adoptopenjdk_url}")
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Could not reach Adoptium API, exiting."
  exit $exit_code
fi

java_version=$(echo "$adoptopenjdk_output" | jq -er '.[] | select(
    (.binary.os == "linux") and
    (.binary.architecture == "x64") and
    (.binary.image_type == "jdk")
  ) | .version.openjdk_version')
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Could not find a version field inside Adoptium API query"
  exit $exit_code
fi

echo "$java_version"
