##!/usr/bin/env bash

install_java(){
    install_java_package
    local java_home
    java_home=$(get_java_home)
    set_java_home "$java_home"
}

check_java(){
    command -v java
    grep -q 'JAVA_HOME' "$BASHRC_FILEPATH"
}

install_java_package(){
    sudo apt-get update
    sudo apt-get install -y default-jdk
}

get_java_home(){
    java -XshowSettings:properties 2>&1 | awk '$1 ~ /java\.home/ {print $3}'
}

set_java_home(){
    local java_home="$1"
    echo "export JAVA_HOME=$java_home" >> "$BASHRC_FILEPATH"
}
