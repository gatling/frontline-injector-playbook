#!/usr/bin/bash


echo "------------------------------------------------------------------------"
echo "-- installing java                                                    --"
echo "------------------------------------------------------------------------"


sudo su <<EOT

curl -O https://download.oracle.com/graalvm/${JAVA_MAJOR}/latest/graalvm-jdk-${JAVA_MAJOR}_linux-aarch64_bin.tar.gz

tar -xzf  graalvm-jdk-${JAVA_MAJOR}_linux-aarch64_bin.tar.gz
rm -f graalvm-jdk-${JAVA_MAJOR}_linux-aarch64_bin.tar.gz

p=\$(ls -t | head -1)
ln -s  ./"\$p"  ./graalvm
echo "ln -s  ./\$p   ./graalvm"


touch /etc/profile/graalvm.sh
chown root:root /etc/profile/graalvm.sh
chmod 644 /etc/profile/graalvm.sh

echo "# /etc/profile.d/graalvm   - graalvm paths  " >> /etc/profile.d/graalvm.sh
echo "export PATH=/opt/graalvm/bin:\$PATH" >> /etc/profile.d/graalvm.sh
echo "export JAVA_HOME=/opt/graalvm" >> /etc/profile.d/graalvm.sh

EOT
