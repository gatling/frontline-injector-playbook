#!/bin/bash

set -eu

java_version="$1"

container_name=system

# current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
# java_version=$("$current_dir/../java-version.sh" "$java_major")

# # Make sure we end up with a valid VHD name
java_version=${java_version//+/_}

mapfile -t vhd_names < <(az storage blob list \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --account-key "$STORAGE_ACCOUNT_KEY" \
  --container-name "$container_name" \
  --query "[?contains(@.name, '$java_version') && ends_with(@.name, 'vhd')].name" \
  --out tsv)

start_date=$(date +%FT%TZ -d "- 1 day" -u)
expiry_date=$(date +%FT%TZ -d "+ 2 month" -u)

for vhd_name in "${vhd_names[@]}"; do
  sas_token=$(az storage container generate-sas \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --account-key "$STORAGE_ACCOUNT_KEY" \
    --name "$container_name" \
    --permissions rl \
    --start "$start_date" \
    --expiry "$expiry_date" | jq -r .)

  echo "https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/$container_name/Microsoft.Compute/Images/$vhd_name?$sas_token"
done
