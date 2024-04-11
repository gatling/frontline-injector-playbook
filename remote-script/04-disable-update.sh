#!/usr/bin bash


echo "------------------------------------------------------------------------"
echo "-- disable upgrade                                                    --"
echo "------------------------------------------------------------------------"

sudo su << EOT
sed -i   's/repo_upgrade: (security|none)/repo_upgrade: none/g' /etc/cloud/cloud.cfg
sed -i   '/repo_upgrade_exclude:/a \ - java*' /etc/cloud/cloud.cfg
EOT
