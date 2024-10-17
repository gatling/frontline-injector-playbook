#!/usr/bin/bash


echo "------------------------------------------------------------------------"
echo "-- installing commons                                                 --"
echo "------------------------------------------------------------------------"

sudo su << EOT
dnf install -y jq
dnf install -y libxcrypt-compat
EOT
