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

@test "checker with if statement" {
    check_test(){
        echo in check >&3
        [ 2 = 2 ]
        [ 1 = 2 ]
        echo $? >&3
        echo after fail >&3
        [ 1 = 1 ]
    }

    checker check_test
    if ! $check;
    then
        false
    fi
    echo $check >&3
    checker true && $check
    echo $check >&3
    checker false
    ! $check
    echo $check >&3
}

@test "checker idem in e option when check fails" {
    local options_plus options_minus
    set +e
    checker false
    options_plus=$(set +o)

    set -e
    checker true
    options_minus=$(set +o)

    echo $options_plus | grep 'set +o errexit'
    echo $options_plus | grep 'set -o errexit'
}

@test "checker idem in e option when check succed" {
    local options_plus options_minus
    set +e
    checker true
    options_plus=$(set +o)

    set -e
    checker true
    options_minus=$(set +o)

    echo $options_plus | grep 'set +o errexit'
    echo $options_plus | grep 'set -o errexit'
}
