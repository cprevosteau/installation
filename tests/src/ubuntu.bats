#!/usr/bin/env bats
load ../import_helpers
load_src ubuntu

setup() {
    # executed before each test
    echo "setup" >&3
    app=test
    LOG_FILE="test.log"
    sudo mv /usr/sbin/reboot /usr/sbin/reboot_
    echo 'echo reboot' | sudo tee /usr/sbin/reboot >/dev/null
    sudo chmod +x /usr/sbin/reboot
    exit() {
        echo exit $1
    }
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    unset exit
    sudo mv /usr/sbin/reboot_ /usr/sbin/reboot
}

@test "test check_or_install when at least one test of check fails" {
    check_test() {
        [ 2 = 2 ] && \
        [ 1 = 2 ] && \
        [ 1 = 1 ]
    }
    spinner_install() {
       echo "$*"
    }

    run check_or_install "$app"

    assert_output "$LOG_FILE $app"
}

@test "test check_or_install when all tests of check succeed" {
    check_test() {
        [ 2 = 2 ] && \
        [ 1 = 1 ]
    }
    spinner_install() {
       echo "$*"
    }
    run_set check_or_install "$app"
    assert_output ""
}

@test "test ask_for_reboot with y answer" {


    local output
    output_y=$(echo "y" | ask_for_reboot)
    output_Y=$(echo "Y" | ask_for_reboot)

    assert_equal "$(echo "$output_y" | tail -n 1 )" 'reboot'
    assert_equal "$(echo "$output_Y" | tail -n 1 )" 'reboot'

}

@test "test ask_for_reboot with n answer" {
    exit() {
        echo exit $1
    }

    local output
    output_n=$(echo "n" | ask_for_reboot)
    output_p=$(echo "p" | ask_for_reboot)

    assert_equal "$(echo "$output_n" | tail -n 1 )" 'exit 0'
    assert_equal "$(echo "$output_p" | tail -n 1 )" 'exit 0'

}
