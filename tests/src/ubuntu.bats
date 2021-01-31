#!/usr/bin/env bats
load ../import_helpers
load_src ubuntu

setup() {
    # executed before each test
    echo "setup" >&3
    app=test
    LOG_FILE="test.log"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "test check_or_install when at least one test of check fails" {
    check_test() {
        echo in check >&3
        [ 2 = 2 ]
        [ 1 = 2 ]
        echo after fail >&3
        [ 1 = 1 ]
    }
    spinner_install() {
       echo "$*"
    }
    local options
    set +e

    output=$(check_or_install "$app")
    options=$(set +o)
    set -e

    assert_output "$LOG_FILE $app install_$app"
    echo $options | grep 'set +o errexit'
}

@test "test check_or_install when all tests of check succeed" {
    check_test() {
        [ 2 = 2 ]
        [ 1 = 1 ]
    }
    spinner_install() {
       echo "$*"
    }

    run_set check_or_install "$app"
    assert_output ""
}

