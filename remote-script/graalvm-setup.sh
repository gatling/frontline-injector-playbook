#!/usr/bin/env bash


mkdir /opt/ -p
cd /opt/

wget https://download.oracle.com/graalvm/22/latest/graalvm-jdk-22_linux-x64_bin.tar.gz

tar -xzvf graalvm-jdk-22_linux-x64_bin.tar.gz
ln -s  ./graalvm-jdk-22+36.1 ./graalvm


echo "# /etc/profile.d/graalvm   - graalvm paths  "
echo "export PATH=/opt/graalvm/bin:\$PATH" >> /etc/profile.d/graalvm.sh
echo "export JAVA_HOME=/opt/graalvm" >> /etc/profile.d/graalvm.sh
