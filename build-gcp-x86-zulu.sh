#!/bin/bash

# Abort on error
set -e
PACKER=$(which packer)
GCP_CLI=$(which gcloud)
#PACKER_LOG=1

function usage
{
    echo "usage: $0  --java-major MAJOR --project-id PROJECT_ID [--help]"
    echo "   ";
    echo "  --java-major        : Java major version";
    echo "  --project-id        : GCP project id";
    echo "  --help              : This message";
}

function parse_args
{
  # positional args
  args=()

  # named args
  while [ "$1" != "" ]; do
      case "$1" in
          --java-major )         java_major="$2";       shift;;
          --project-id )         project_id="$2";       shift;;
          --help )               usage;                 exit;; # quit and show usage
          * )                    args+=("$1")           # if no match, add it to the positional args
      esac
      shift # move to next kv pair
  done

  # Validate required args
  if [[ -z "${java_major}" || -z "${project_id}" ]]; then
      echo "Invalid arguments"
      usage
      exit;
  fi

}

function run
{

  parse_args "$@"

  . lib/log.sh
  . lib/java-latest-version.sh $java_major "x86"

  build_id=`date +%s | sha1sum | cut -c -4`

  log info "Build Gatling Enterprise Injector x86_64 (build_id: $build_id)"
  log info "Project ID: ${project_id} "
  log info "OpenJDK version: $java_version"

  ${PACKER} build \
   -var "java_major=$java_major" \
   -var "java_version=$java_version" \
   -var "project_id=$project_id" \
   -var "build_id=$build_id" \
   ./packer/gcp-x86-zulu.pkr.hcl 

  export CLOUDSDK_CONFIG=$GOOGLE_APPLICATION_CREDENTIALS 


	$GCP_CLI --project "$project_id" compute images \
    add-iam-policy-binding "classic-openjdk-${java_major}-${build_id}" \
    --member="allAuthenticatedUsers" \
    --role="roles/compute.imageUser"

}

run "$@";
