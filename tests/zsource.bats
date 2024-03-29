#!/usr/bin/env bats

load test_helper
load '../src/zsource'

@test "zsource fails if provided an empty string" {
    # Given an empty string
    file=''

    # When the empty string is provided to zsource
    run zsource "$file"

    # Then zsource should fail
    assert_failure
}

@test "zsource fails if provided a nonexistent file" {
    # Given a nonexistent file
    file="tests/assets/fake_zsh_script.sh"
    refute [ -e "$file" ]

    # When that file is provided to zsource
    run zsource "$file"

    # Then zsource should fail
    assert_failure
}

@test "zsource fails if the provided file isn't executable" {
    # Given a non-executable file
    file="tests/assets/non_executable_main.sh"
    refute [ -x "$file" ]

    # When that file is provided to zsource
    run zsource "$file"

    # Then zsource should fail
    assert_failure
}

@test "zsource succeeds if provided an existing, executable file" {
    # Given an existing, executable zsh file
    file="tests/assets/main.sh"
    assert [ -x "$file" ]

    # When that file is provided to zsource
    run zsource "$file"

    # Then zsource should succeed
    assert_success
}

@test "zsource doesn't set ${BATS_TEST_TMPDIR}/zsource if provided an empty string" {
    # Given an empty string
    file=''

    # When the empty string is provided to zsource
    zsource "$file" || true

    # Then $BATS_TMPDIR/bats-zsh should be empty
    assert_equal "$(cat ${BATS_TEST_TMPDIR}/zsource)" ""
}

@test "zsource doesn't set ${BATS_TEST_TMPDIR}/zsource if provided a non-existent file" {
    # Given a nonexistent file
    file="tests/assets/fake_zsh_script.sh"
    refute [ -e "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then $BATS_TMPDIR/bats-zsh should be empty
    assert_equal "$(cat ${BATS_TEST_TMPDIR}/zsource)" ""
}

@test "zsource doesn't set ${BATS_TEST_TMPDIR}/zsource if provided a non-executable file" {
     # Given a non-executable file
    file="tests/assets/non_executable_main.sh"
    refute [ -x "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then $BATS_TMPDIR/bats-zsh should be empty
    assert_equal "$(cat ${BATS_TEST_TMPDIR}/zsource)" ""
}

@test "zsource sets ${BATS_TEST_TMPDIR}/zsource to the provided file's path if it's existing and executable" {
    # Given an existing, executable zsh file
    file="tests/assets/main.sh"
    assert [ -x "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then $BATS_TMPDIR/bats-zsh should contain to the file's path
    assert_equal "$(cat ${BATS_TEST_TMPDIR}/zsource)" "$file"
}

@test "zsource can source multiple files" {
    # Given 2 existing, executable zsh files
    file1="tests/assets/main.sh"
    assert [ -x "$file1" ]
    file2="tests/assets/main2.sh"
    assert [ -x "$file2" ]

    # When both files are provided to zsource
    zsource "$file1" || true
    zsource "$file2" || true

    # Then $BATS_TMPDIR/bats-zsh should contain both files' paths
    content1="$(cat ${BATS_TEST_TMPDIR}/zsource | grep "$file1")"
    assert_not_equal "$content1" ""

    content2="$(cat ${BATS_TEST_TMPDIR}/zsource | grep "$file2")"
    assert_not_equal "$content2" ""
}
