#!/bin/bash

set -eu

default_bundle="jre"
java_major="$1"
arch="$2"

zulu_url="https://api.azul.com/metadata/v1/zulu/packages/?java_version=${java_major}&os=linux-glibc&arch=${arch}&archive_type=tar.gz&java_package_type=jre&javafx_bundled=false&crac_supported=false&crs_supported=true&latest=true&release_status=ga&availability_types=CA&certifications=tck"

zulu_output=$(curl -Lfs "${zulu_url}")
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Could not reach Zulu API, exiting."
  exit $exit_code
fi

java_version=$(echo "$zulu_output" | jq '.[0].distro_version | _nwise(3)| join(".")' | jq --slurp | jq 'join("+")' -r)
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Could not find a version field inside Zulu API query"
  exit $exit_code
fi
