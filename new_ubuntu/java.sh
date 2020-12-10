##!/usr/bin/env bash
set -ex

sudo apt-get install -y default-jdk
JAVA_HOME=`java -XshowSettings:properties 2>&1 | awk '$1 ~ /java\.home/ {print $3}'`
echo "export JAVA_HOME=$JAVA_HOME" >> $BASHRC_FILE
