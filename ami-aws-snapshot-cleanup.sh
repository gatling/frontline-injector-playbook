#!/bin/env bash

set -e
AWS_CLI=$(which aws)

function usage
{
    echo "usage: $0 --ami-name AMI-NAME --profile AWS_PROFILE [--help]"
    echo "   ";
		echo "  --ami-name          : ami name field";
		echo "  --profile           : AWS Profile";
    echo "  --help              : This message";
}

function parse_args
{
  # positional args
  args=()

  # named args
  while [ "$1" != "" ]; do
      case "$1" in
          --ami-name )    image_filter="$2";     shift;;
          --profile )            aws_profile="$2";      shift;;
          --help )               usage;                 exit;; # quit and show usage
          * )                    args+=("$1")           # if no match, add it to the positional args
      esac
      shift # move to next kv pair
  done

  # Validate required args
  if [[ -z "${image_filter}"  || -z "${aws_profile}" ]]; then
      echo "Invalid arguments"
      usage
      exit;
  fi

}


function run 
{
  parse_args "$@"

  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION
  
  rm -f ./found_amis delete
  timestamp=$(date "+%Y%m%d-%H%M%S")
  declare -a REGIONS=($($AWS_CLI ec2 describe-regions --profile $aws_profile --output json | jq '.Regions[].RegionName' | tr "\\n" " " | tr -d "\""  ))
 
  echo "#!/usr/bin/env bash" > delete_script.$timestamp
  echo "set -e"  >> delete_script.$timestamp
  echo "unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION" > delete_script.$timestamp
  
  for r in "${REGIONS[@]}" ; do
    ami=$($AWS_CLI ec2 describe-images --profile $aws_profile --query 'Images[*].[ImageId]' --filters "Name=name,Values=${image_filter}" --region ${r} --output json | jq -r '.[0][0]')
    printf "\rprocessing region: ${r}                  "
    echo "echo region: ${r}">> delete_script.$timestamp
  
    # Search and generate deletion for ami
    [[ "$ami" != "null" ]]  && echo $AWS_CLI ec2 deregister-image --profile $aws_profile --region ${r} --image-id "${ami}" >> delete_script.$timestamp
    
    # Search and generate deletion for snapshots
    snapshots=$($AWS_CLI ec2 describe-snapshots --profile $aws_profile --owner-ids self  --query 'Snapshots[]' --region=$r --output json )
    [[ "$snapshots" != "null" ]]  &&  snapshot_id=$(echo $snapshots | jq '.[] | select(.Description|test("Created by CreateImage.*'$ami'$")).SnapshotId')
    [[ "X$snapshot_id" != "X" ]]  && echo $AWS_CLI ec2 delete-snapshot --profile $aws_profile --snapshot-id "$snapshot_id" --region ${r}  >> delete_script.$timestamp
    
    # Search and generate deletion for snapshots copies
    [[ "$snapshots_copy" != "null" ]]  &&  snapshot_copy_id=$(echo $snapshots | jq '.[] | select(.Description|test("Copied for DestinationAmi.*'$ami'.*")).SnapshotId')
    [[ "X$snapshot_copy_id" != "X" ]]  && echo $AWS_CLI ec2 delete-snapshot --profile $aws_profile --snapshot-id "$snapshot_copy_id" --region ${r}  >> delete_script.$timestamp
   #    
  done
  
  echo ""
  echo "delete_script.$timestamp generated"
  
  bat ./delete_script.$timestamp
  
  echo -n "type 'apply' to execute :"
  read ok_apply
  
  [[ $ok_apply == "apply" ]] && cat ./delete_script.$timestamp | bash
}

run "$@";
