#!/bin/bash

# Abort on error
set -e
PACKER=$(which packer)
GCP_CLI=$(which gcloud)
#PACKER_LOG=1

function usage
{
    echo "usage: $0  --java-major MAJOR --client-id CLIENT_ID --client-secret CLIENT_SECRET --ssh-private-key SSH_PRIVATE_KEY_FILE --subscription-id SUBSCRIPTION_ID [--help]"
    echo "   ";
    echo "  --java-major        : Java major version";
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
          --help )               usage;                 exit;; # quit and show usage
          * )                    args+=("$1")           # if no match, add it to the positional args
      esac
      shift # move to next kv pair
  done

  # Validate required args
  if [[ -z "${java_major}" ]]; then
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

#  log info "Build Gatling Enterprise Injector x86_64 (build_id: $build_id)"
#  log info "Project ID: ${project_id} "
#  log info "OpenJDK version: $java_version"
#
#  ${PACKER} build \
#   -var "java_major=$java_major" \
#   -var "java_version=$java_version" \
#   -var "project_id=$project_id" \
#   -var "build_id=$build_id" \
#   ./packer/gcp-x86-zulu.pkr.hcl 

  #-var "ssh_private_key_file=$AZURE_SSH_PRIVATE_KEY_FILE" \
packer build \
  -var "java_major=$java_major" \
  -var "java_version=$java_version" \
  -var "client_id=$AZURE_CLIENT_ID" \
  -var "client_secret=$AZURE_CLIENT_SECRET" \
  -var "subscription_id=$AZURE_SUBSCRIPTION_ID" \
  -var "tenant_id=$AZURE_TENANT_ID" \
  -var "build_id=$build_id" \
  packer/azure-x86-zulu.pkr.hcl
}

run "$@";
