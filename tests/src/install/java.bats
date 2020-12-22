#!/usr/bin/env bats
load ../../import_helpers
load_src install/java

setup() {
    # executed before each test
    echo "setup" >&3
}

teardown() {
    # executed after each test
    echo "teardown" >&3
}

@test "get java home" {
    java() {
        cat <<EOF >&2
    java.awt.graphicsenv = sun.awt.X11GraphicsEnvironment
    java.awt.printerjob = sun.print.PSPrinterJob
    java.class.path =
    java.class.version = 55.0
    java.home = /usr/lib/jvm/java-11-openjdk-amd64
    java.io.tmpdir = /tmp
    java.library.path = /usr/java/packages/lib
EOF
    }
    run_set get_java_home
    assert_output /usr/lib/jvm/java-11-openjdk-amd64
}

@test "set java home" {
    local before actual_added_line
    before=$( grep "JAVA_HOME" "$BASHRC_FILEPATH" || echo "")
    assert_equal "$before" ""

    cmd_set set_java_home "test/path"

    local actual_added_line
    actual_added_line=$( grep "JAVA_HOME" "$BASHRC_FILEPATH")
    assert_equal "$actual_added_line" "export JAVA_HOME=test/path"

}