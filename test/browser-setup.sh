#!/usr/bin/bash
#
# Runs remote-script/05-browser-setup.sh in a container standing in for a VM, then the browser smoke test as a non-root
# user with a login shell, so with the variables of /etc/profile.d/gatling-browser.sh.
# Usage, from the repository root, with the playwright-core package extracted in ./playwright-core:
#   docker run --rm --volume "$PWD:/playbook:ro" <debian:trixie|amazonlinux:2023> bash /playbook/test/browser-setup.sh
set -Eeuo pipefail

if command -v dnf > /dev/null; then
  # not in the amazonlinux container, present on the Amazon Linux 2023 AMIs
  dnf install -y shadow-utils util-linux
fi

bash /playbook/remote-script/05-browser-setup.sh

useradd --create-home tester
su --login tester --command '"$PLAYWRIGHT_NODEJS_PATH" /playbook/test/browser-smoke.js /playbook/playwright-core'
