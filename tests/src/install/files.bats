#!/usr/bin/env bats
load ../../import_helpers
load_src install/files

setup() {
    # executed before each test
    echo "setup" >&3
    mounted_dir="/tmp/mounted"
    target_dir="/tmp/target"
    mkdir -p "$target_dir"
    src_file_path="/tmp/files/test.test"
    create_file "$src_file_path"
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    delete_if_file_exist "$src_file_path"
    delete_if_directory_exist "$target_dir"
    delete_if_directory_exist "$mounted_dir"
}

@test "test set file via mounted dir" {

    assert_dir_not_exist "$mounted_dir"
    assert_file_not_exist "$target_dir/$(basename $src_file_path)"

    cmd_set set_file_via_tmp_mount_directory "$src_file_path" "$target_dir"

    assert_dir_not_exist "$mounted_dir"
    assert_file_exist "$target_dir/$(basename $src_file_path)"

}

@test "test cp with env subst" {

    assert_dir_not_exist "$mounted_dir"
    assert_file_not_exist "$target_dir/$(basename $src_file_path)"
    export TEST_VAR="koujougoujougou"
    # shellcheck disable=SC2016
    echo '$TEST_VAR' > "$src_file_path"

    cmd_set cp_with_env_subst "$src_file_path" "$target_dir"

    assert_file_exist "$target_dir/$(basename $src_file_path)"
    grep 'koujougoujougou' "$target_dir/$(basename $src_file_path)"
}
