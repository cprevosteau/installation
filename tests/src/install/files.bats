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
}

teardown() {
    # executed after each test
    echo "teardown" >&3
    delete_if_file_exist "$src_file_path"
    delete_if_directory_exist "$target_dir"
    sudo umount "$mounted_dir" || true
    delete_if_directory_exist "$mounted_dir"
}

@test "test set file via mounted dir" {

    assert_dir_not_exist "$mounted_dir"
    assert_file_not_exist "$target_dir/$filename"
    create_file "$target_dir/test/$filename"
    echo "old_file" >"$target_dir/test/$filename"
    echo "new_file" >"$src_file_path"
    mkdir "/tmp/mounted_target"
    sudo mount --bind "/tmp/mounted_target" "$target_dir"
    assert_dir_not_exist "$target_dir/test"

    cmd_set set_file_via_tmp_mount_directory "$src_file_path" "$target_dir/test" ''


    assert_dir_not_exist "$mounted_dir"
    sudo umount "$target_dir"
    assert_file_exist "$target_dir/test/$filename"
    assert_equal "$(cat $target_dir/test/$filename)" 'new_file'

}

@test "find first mountpoint from path" {
  # Given
  mkdir -p "$mounted_dir"
  sudo mount --bind "$target_dir" "$mounted_dir"
  local subfolder="test/testi/testo"
  mkdir -p "$mounted_dir/$subfolder"

  # When
  actual_found=$(cmd_set find_first_mountpoint "$mounted_dir/$subfolder")

  # Then
  assert_equal "$actual_found" "$mounted_dir"
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
