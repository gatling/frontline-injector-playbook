#!/bin/bash

# Abort on error
set -e
PACKER=$(which packer)
AWS_CLI=$(which aws)
#PACKER_LOG=1

function usage
{
    echo "usage: $0 --java-major MAJOR --copy-regions [true|false] --profile AWS_PROFILE --latest [true|false] [--help]"
    echo "   ";
    echo "  --java-major        : Java major version";
    echo "  --copy-regions      : true or false";
    echo "  --profile           : AWS Profile";
    echo "  --latest            : Want latest ?";
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
          --profile )            aws_profile="$2";      shift;;
          --latest )             latest="$2";           shift;;
          --help )               usage;                 exit;; # quit and show usage
          * )                    args+=("$1")           # if no match, add it to the positional args
      esac
      shift # move to next kv pair
  done

  # Validate required args
  if [[ -z "${java_major}" || -z "${copy_regions}" || -z "${aws_profile}" || -z "${latest}" ]]; then
      echo "Invalid arguments"
      usage
      exit;
  fi

}

function run
{
  parse_args "$@"

  . lib/log.sh

	build_id=`date +%s | sha1sum | cut -c -4`

	log info "Build Gatling Enterprise Injector arm64 (build_id: $build_id)"
	log info "AWS profile: $aws_profile"

  java_version=$java_major
    
	copy_regions_list="[]"
	if [ $copy_regions == "true" ]
	then
    copy_regions_list=$($AWS_CLI ec2 describe-regions --region=eu-west-3 --query "Regions[?RegionName != 'eu-west-3'].RegionName" --output json | tr -s '[:blank:]' ' ')
	  log info "Copy regions: $copy_regions_list"
	fi

	if [ -f ~/.aws/config ]
	then
		unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION
	fi

	ami_description="classic-graalvm-$java_major"
	if [ $latest == "true" ]
	then
	    ami_description="classic-graalvm-latest"
	fi

	log info "AMI description: $ami_description"

	$PACKER build \
	  -var "aws_profile=$aws_profile" \
	  -var "build_id=$build_id" \
	  -var "java_major=$java_major" \
	  -var "java_version=$java_version" \
	  -var "copy_regions=$copy_regions_list" \
	  -var "ami_description=$ami_description" \
	  packer/aws-arm-graal.pkr.hcl
}

run "$@";
