#!/bin/bash
#
# Writes result.json, the result of one image built by .github/workflows/release.yml, read by
# the Slack summary of the notify job.
#
# Environment:
#   NAME     image of the catalogue, e.g. "aws-x86 java-lts"
#   OUTCOME  outcome of the build step: success, failure, cancelled, skipped
#   START    start of the job (seconds since the epoch)
#   IMAGE    AMI ID or GCP image name, empty when no image was created
#   ZULU     Zulu version of a Zulu image (25.38.201+0 or 25.38.201-0), optional
#   GRAALVM  GraalVM version of a GraalVM image, optional
#
# For a Zulu image, the JDK version (25.0.5.1) is read from the Azul API; if the API does
# not answer, the summary shows the Zulu version only.
#
# Needs jq and curl.

set -euo pipefail

zulu="${ZULU:-}"
zulu="${zulu%%[+-]*}"

jdk=""
if [ -n "$zulu" ]; then
  jdk=$(curl -fsS --max-time 20 "https://api.azul.com/metadata/v1/zulu/packages/?distro_version=${zulu}&os=linux-glibc&archive_type=tar.gz&java_package_type=jre&release_status=ga" \
    | jq -r '[.[].java_version | map(tostring) | join(".")] | unique | first // empty' || true)
fi

jq -n \
  --arg name "$NAME" \
  --arg outcome "$OUTCOME" \
  --arg image "${IMAGE:-}" \
  --arg zulu "$zulu" \
  --arg jdk "$jdk" \
  --arg graalvm "${GRAALVM:-}" \
  --argjson duration "$(( $(date +%s) - START ))" \
  'def nonempty: if . == "" then null else . end;
   {name: $name, outcome: $outcome, image: ($image | nonempty), duration: $duration,
    zulu: ($zulu | nonempty), jdk: ($jdk | nonempty), graalvm: ($graalvm | nonempty)}' \
  | tee result.json
