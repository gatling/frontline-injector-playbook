#!/bin/bash

# Abort on error
set -e
PACKER=$(which packer)
GCP_CLI=$(which gcloud)
#PACKER_LOG=1

function usage
{
  # --profile AWS_PROFILE 
    echo "usage: $0  --java-major MAJOR --copy-regions [true|false] [--help]"
    echo "   ";
    echo "  --java-major        : Java major version";
    echo "  --creds-file        : credentials file path";
		echo "  --copy-regions      : true or false";
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
          --copy-regions )       copy_regions="$2";     shift;;
          --creds-file )         creds_file="$2";       shift;;
          --help )               usage;                 exit;; # quit and show usage
          * )                    args+=("$1")           # if no match, add it to the positional args
      esac
      shift # move to next kv pair
  done

  # Validate required args
  if [[ -z "${java_major}" || -z "${creds_file}" || -z "${copy_regions}" ]]; then
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
	log info "Using credentials from : ${creds_file} "
	log info "OpenJDK version: $java_version"


  #java_major="$1"
  # java_version="$2"
  # java_vendor="$3"
  #java_bundle_type="${4:-$default_bundle}"

  # gcloud auth login --cred-file=
  # from
  # https://console.cloud.google.com/iam-admin/serviceaccounts/details/106217051786760899362/keys?orgonly=true&project=frontline-testing-254714&supportedpurview=organizationId
  # gcloud auth application-default login
  project_id=$(jq -r .project_id < "${creds_file}")
#  ssh_username=google-user
#  zone=europe-west1-b


 # [[ "$java_vendor" != "zulu" ]]&&[[ "$java_bundle_type" != ""  ]]&& echo "java bundle type is ignored for other vendor than Zulu"

  packer build \
   -var "java_major=$java_major" \
   -var "java_version=$java_version" \
   -var "project_id=$project_id" \
   -var "build_id=$build_id" \
   ./packer/gcp-x86-zulu.pkr.hcl 

exit 0
# Share custom images publicly: https://cloud.google.com/compute/docs/images/managing-access-custom-images#gcloud_4
	if [ $copy_regions == "true" ]
  then
    if [ -f manifest.json ] 
    then
      mapfile -t artifacts < <(jq -r ".builds[].artifact_id" < manifest.json)
      for artifact in "${artifacts[@]}"; do
        $GCP_CLI --project "$project_id" compute images add-iam-policy-binding "$artifact" \
          --member="allAuthenticatedUsers" \
          --role="roles/compute.imageUser"
      done
    else
      echo "Could not find ``manifest.json`` file."
      exit 1
    fi
  fi
}

run "$@";
