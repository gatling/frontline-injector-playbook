#!/bin/bash

# Abort on error
set -e
PACKER=$(which packer)
# GCP_CLI=$(which gcloud)
#PACKER_LOG=1

function usage
{
    echo "usage: $0  --java-major MAJOR --graalvm-version VERSION --client-id CLIENT_ID --client-secret CLIENT_SECRET --subscription-id SUBSCRIPTION_ID --tenand-id TENANT_ID --image-version IMAGE_VERSION [--help]"
    echo "   ";
    echo "  --java-major        : Java major version";
    echo "  --graalvm-version    : Graalvm version with minor";
    echo "  --client-id         : Azure Client ID";
    echo "  --client-secret     : Azure Client Secret";
    echo "  --subscription-id   : Azure Subscription ID";
    echo "  --tenant-id         : Azure Tenant ID";
    echo "  --image-version     : Azure Image Version";
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
          --graalvm-version )    graalvm_version="$2";       shift;;
          --client-id )          client_id="$2";        shift;;
          --client-secret )      client_secret="$2";    shift;;
          --subscription-id )    subscription_id="$2";  shift;;
          --tenant-id )          tenant_id="$2";        shift;;
          --image-version )      image_version="$2";    shift;;
          --help )               usage;                 exit;; # quit and show usage
          * )                    args+=("$1")           # if no match, add it to the positional args
      esac
      shift # move to next kv pair
  done

  # Validate required args
  if [[ -z "${java_major}" || -z "${client_id}" || -z "${client_secret}" || -z "${subscription_id}" || -z "${tenant_id}" || -z "${image_version}" || -z "${graalvm_version}"" ]]; then
      echo "Invalid arguments"
      usage
      exit
  fi

}

function run
{

  parse_args "$@"

  . lib/log.sh
  # . lib/java-latest-version.sh $java_major "x86"

	build_id=`date +%s | sha1sum | cut -c -4`

  log info "Build Gatling Enterprise Injector x86_64 (build_id: $build_id)"
	log info "Image version: $image_version"
  log info "OpenJDK version: $graalvm_version"
  log info "Client ID: ${client_id} "
  log info "Subscription ID: ${subscription_id} "
  log info "Tenant ID: ${tenant_id} "

	$PACKER build \
	  -var "java_major=$java_major" \
	  -var "graalvm_version=$graalvm_version" \
	  -var "client_id=$client_id" \
	  -var "client_secret=$client_secret" \
	  -var "subscription_id=$subscription_id" \
	  -var "tenant_id=$tenant_id" \
	  -var "image_version=$image_version" \
	  -var "build_id=$build_id" \
	  packer/azure-x86-graal.pkr.hcl
}

run "$@";
