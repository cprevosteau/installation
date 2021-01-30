#!/usr/bin/env bats
load ../../import_helpers
load_src install/explorer

setup() {
    # executed before each test
    echo "setup" >&3
    bookmark_file="$GTK3_CONFIG_DIR/bookmarks"
    cat <<EOF >"${bookmark_file}"
file:///home/clement
file;///home/clement/Downloads
EOF
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "add_folders_to_bookmark" {
    # Given
    local folder1 folder2 expected_line_number expecteed_third_line expecteed_fourth_line bookmark_lines third_line fourth_line
    folder1="/test/test1"
    folder2="/test2/test3"
    expected_line_number=4
    expecteed_third_line="file://${folder1}"
    expecteed_fourth_line="file://${folder2}"

    # When
    run_set add_folders_to_bookmark "${folder1}" "${folder2}"
    assert_success

    # THen
    assert_file_exist "${bookmark_file}"
    bookmark_lines=$( wc -l <"${bookmark_file}")
    third_line=$( awk 'NR==3 {print}' "${bookmark_file}")
    fourth_line=$( awk 'NR==4 {print}' "${bookmark_file}")
    assert_equal "${bookmark_lines}" "${expected_line_number}"
    assert_equal "${third_line}" "${expecteed_third_line}"
    assert_equal "${fourth_line}" "${expecteed_fourth_line}"
}