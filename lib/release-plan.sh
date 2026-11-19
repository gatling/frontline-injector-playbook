#!/bin/bash
#
# Lists, as a JSON array, the images of the catalogue selected by the filters of
# .github/workflows/release.yml. Each image carries its build script and its options.
#
# usage: lib/release-plan.sh CATALOGUE CLOUD ARCH VARIANT LATEST
#   CLOUD:   all, aws, gcp, azure
#   ARCH:    all, x86, arm
#   VARIANT: all or a variant of the catalogue
#   LATEST:  all, true, false
#
# Needs yq (mikefarah, v4) and jq.

set -euo pipefail

if [ "$#" -ne 5 ]; then
  echo "usage: $0 CATALOGUE CLOUD ARCH VARIANT LATEST" >&2
  exit 1
fi

catalogue="$1"
repo_dir=$(dirname "$catalogue")

images=$(yq -o=json '.' "$catalogue" | jq -c \
  --arg cloud "$2" --arg arch "$3" --arg variant "$4" --arg latest "$5" '
  . as $catalogue
  | [
      $catalogue.platforms[] as $platform
      | ($platform | split("-")) as [$platform_cloud, $platform_arch]
      | $catalogue.variants | to_entries[] as $variant
      | ($catalogue.jdks[$variant.value.jdk]
          // error("variant \($variant.key): unknown jdk \($variant.value.jdk)")) as $jdk
      | {
          name: "\($platform) \($variant.key)",
          platform: $platform,
          cloud: $platform_cloud,
          arch: $platform_arch,
          variant: $variant.key,
          latest: $jdk.latest,
          build: $variant.value.build,
          script: "build-\($platform)-\($variant.value.build).sh",
          template: "packer/\($platform)-\($variant.value.build).pkr.hcl",
          # every key of the JDK becomes an option; the Azure scripts take no --latest
          options: (
            [ $jdk | to_entries[]
              | select(.key != "latest" or $platform_cloud != "azure")
              | "--\(.key | gsub("_"; "-")) \(.value)" ]
            | join(" ")
          )
        }
    ]
  | map(select(
      ($cloud == "all" or .cloud == $cloud)
      and ($arch == "all" or .arch == $arch)
      and ($variant == "all" or .variant == $variant)
      and ($latest == "all" or (.latest | tostring) == $latest)
    ))
  ')

# a missing script or template is a catalogue error: stop before any build
missing=$(jq -r '.[] | .script, .template' <<<"$images" | sort -u | while read -r file; do
  if [[ "$file" == *.sh ]]; then
    [ -x "$repo_dir/$file" ] || echo "$file"
  else
    [ -f "$repo_dir/$file" ] || echo "$file"
  fi
done)
if [ -n "$missing" ]; then
  echo "Build scripts or Packer templates not found: $missing" >&2
  exit 1
fi

if [ "$(jq 'length' <<<"$images")" -eq 0 ]; then
  echo "No image matches the filters." >&2
  exit 1
fi

echo "$images"
