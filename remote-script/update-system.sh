#!/usr/bin/env bash


echo "------------------------------------------------------------------------"
echo "-- updating system                                                    --"
echo "------------------------------------------------------------------------"

sudo su << EOT
yum update -y
yum upgrade -y
EOT
