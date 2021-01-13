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
    filename="test.test"
    create_file "$src_file_path"
    assert_file_not_exist "$target_dir/$filename"
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

    cmd_set set_file_via_tmp_mount_directory "$src_file_path" "$target_dir" ''

    assert_dir_not_exist "$mounted_dir"
    assert_file_exist "$target_dir/$(basename $src_file_path)"

}

@test "test cp with env subst" {

    assert_dir_not_exist "$mounted_dir"
    assert_file_not_exist "$target_dir/$(basename $src_file_path)"
    export TO_BE_REPLACED1="koujougoujougou"
    export TO_BE_REPLACED2="koukou"
    # shellcheck disable=SC2016
    echo '$TO_BE_REPLACED1 $TO_BE_REPLACED2 $NOT_TO_BE_REPLACED' >"$src_file_path"
    cmd_set cp_with_env_subst "$src_file_path" "$target_dir" \
                              '$TO_BE_REPLACED1 $TO_BE_REPLACED2'
    assert_file_exist "$target_dir/$filename"
    grep "$TO_BE_REPLACED" "$target_dir/$filename" >&3
    grep "$TO_BE_REPLACED2 " "$target_dir/$filename"
    grep '$NOT_TO_BE_REPLACED' "$target_dir/$filename"
}
