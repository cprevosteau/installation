#!/usr/bin/env bats
load '../test_helpers/bats-support/load'
load '../test_helpers/bats-assert/load'
load '../test_helpers/bats-file/load'

setup() {
    # executed before each test
    echo "setup" >&3
#    load '../../src/import_src_and_env' >&3
#    sudo mv /usr/bin/bats /tmp
#    load "${SRC_DIR}/bats.bash"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
#    sudo mv /tmp/bats /usr/bin
}

@test "install_bats" {
#    run install_bats
#    command -v bats
  assert_dir_exist /home/clement/
#    assert_dir_exist "${APP_DIR}/bats-core"
#    assert_file_exist /usr/bin/bats
}