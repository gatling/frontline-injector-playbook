#!/usr/bin/env bash


echo "------------------------------------------------------------------------"
echo "-- wait cloud init ends                                               --"
echo "------------------------------------------------------------------------"

sudo su << EOT
while ! grep "Cloud-init .* finished" /var/log/cloud-init.log; do
    echo "$(date -Ins) Waiting for cloud-init to finish"
    sleep 2
done
sleep 30
EOT
