#!/usr/bin/bash


echo "------------------------------------------------------------------------"
echo "-- installing java                                                    --"
echo "------------------------------------------------------------------------"


sudo su <<EOT
mkdir -p /opt
cd /opt

curl -LO https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${JAVA_MAJOR}.0.0/graalvm-community-jdk-${JAVA_MAJOR}.0.0_linux-x64_bin.tar.gz
tar -xzf graalvm-community-jdk-${JAVA_MAJOR}.0.0_linux-x64_bin.tar.gz
rm -f graalvm-community-jdk-${JAVA_MAJOR}.0.0_linux-x64_bin.tar.gz

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
