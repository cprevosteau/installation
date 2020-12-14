#!/usr/bin/env bats
load ../import_helpers

setup() {
    # executed before each test
    echo "setup" >&3
    load_src install/intellij_pycharm
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "real install intellij pycharm" {
    
}