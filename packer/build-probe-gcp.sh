#!/bin/bash

set -eu

java_major="$1"
java_version="$2"

project_id=$(jq -r .project_id < "$GOOGLE_APPLICATION_CREDENTIALS")
ssh_username=google-user
zone=europe-west1-b

packer build \
  -var "java_major=$java_major" \
  -var "java_version=$java_version" \
  -var "project_id=$project_id" \
  -var "ssh_username=$ssh_username" \
  -var "zone=$zone" \
  template-probe-gcp.json

# Share custom images publicly: https://cloud.google.com/compute/docs/images/managing-access-custom-images#gcloud_4

if [ -f manifest.json ]; then
  mapfile -t artifacts < <(jq -r ".builds[].artifact_id" < manifest.json)
  for artifact in "${artifacts[@]}"; do
    gcloud --project "$project_id" compute images add-iam-policy-binding "$artifact" \
      --member="allAuthenticatedUsers" \
      --role="roles/compute.imageUser"
  done
else
  echo "Could not find ``manifest.json`` file."
  exit 1
fi
