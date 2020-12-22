#!/usr/bin/env bats
load ../import_helpers
load_src install/java

setup() {
    # executed before each test
    echo "setup" >&3
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    sudo apt-get remove -y --purge openjdk*
}

@test "install_java_package" {
    refute [ "$(command -v java)" ]
    cmd_set install_java_package >&3
    assert [ "$(command -v java)" ]
}

@test "install_java" {
    refute [ "$(command -v java)" ]
    cmd_set install_java

    assert [ "$(command -v java)" ]
    local java_home
    # shellcheck disable=SC2016
    java_home=$(env -i bash -ic 'echo $JAVA_HOME')
    [ ! "$java_home" = "" ]
}