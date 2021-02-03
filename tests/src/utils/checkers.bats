#!/usr/bin/env bats
load ../../import_helpers
load_src utils/checkers

setup() {
    # executed before each test
    echo "setup" >&3
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "checker" {
    check_test(){
        echo in check >&3
        [ 2 = 2 ]
        [ 1 = 2 ]
        echo $? >&3
        echo after fail >&3
        [ 1 = 1 ]
    }

    run checker check_test
    assert_failure

    local options
    set +e
    checker true
    options=$(set +o)
    set -e

    echo $options | grep 'set +o errexit'
}
