#!/usr/bin/bash


echo "------------------------------------------------------------------------"
echo "-- updating system                                                    --"
echo "------------------------------------------------------------------------"

sudo su << EOT
apt-get update 
apt-get upgrade -y
apt-get dist-upgrade -y
EOT
