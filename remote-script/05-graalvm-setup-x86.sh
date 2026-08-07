#!/usr/bin/bash
set -Eeuo pipefail


echo "------------------------------------------------------------------------"
echo "-- installing java                                                    --"
echo "------------------------------------------------------------------------"


sudo su <<EOT
mkdir -p /opt
cd /opt

curl -LO -fhttps://github.com/graalvm/graalvm-ce-builds/releases/download/graal-${GRAALVM_VERSION}/graalvm-community-jdk-${JAVAVM_VERSION}_linux-x64_bin.tar.gz

tar -xzf graalvm-community-jdk-${JAVAVM_VERSION}_linux-x64_bin.tar.gz || exit 1
rm -f graalvm-community-jdk-${JAVAVM_VERSION}_linux-x64_bin.tar.gz || exit 1

p=\$(ls -t | head -1)
ln -s  ./"\$p"  ./graalvm
echo "ln -s  ./\$p   ./graalvm"

touch /etc/profile.d/graalvm.sh
chown root:root /etc/profile.d/graalvm.sh
chmod 644 /etc/profile.d/graalvm.sh

echo "# /etc/profile.d/graalvm   - graalvm paths  " >> /etc/profile.d/graalvm.sh
echo "export PATH=/opt/graalvm/bin:\$PATH" >> /etc/profile.d/graalvm.sh
echo "export JAVA_HOME=/opt/graalvm" >> /etc/profile.d/graalvm.sh

ln -s /opt/graalvm/bin/java /usr/bin/java
EOT
