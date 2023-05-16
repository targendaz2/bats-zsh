#!/usr/bin/env bats

load test_helper
load '../load'

teardown() {
    rm -f "${TMPDIR}bats-zsh"
}

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
    file="test/assets/fake_zsh_script.sh"
    refute [ -e "$file" ]

    # When that file is provided to zsource
    run zsource "$file"

    # Then zsource should fail
    assert_failure
}

@test "zsource fails if the provided file isn't executable" {
    # Given a non-executable file
    file="test/assets/non_executable_main.sh"
    refute [ -x "$file" ]

    # When that file is provided to zsource
    run zsource "$file"

    # Then zsource should fail
    assert_failure
}

@test "zsource succeeds if provided an existing, executable file" {
    # Given an existing, executable zsh file
    file="test/assets/main.sh"
    assert [ -x "$file" ]

    # When that file is provided to zsource
    run zsource "$file"

    # Then zsource should succeed
    assert_success
}

@test "zsource doesn't set \$TMPDIR/project-name if provided an empty string" {
    # Given an empty string
    file=''

    # When the empty string is provided to zsource
    zsource "$file" || true

    # Then $TMPDIR/bats-zsh should be empty
    assert_equal "$(cat ${TMPDIR}bats-zsh)" ""
}

@test "zsource doesn't set \$TMPDIR/project-name if provided a non-existent file" {
    # Given a nonexistent file
    file="test/assets/fake_zsh_script.sh"
    refute [ -e "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then $TMPDIR/bats-zsh should be empty
    assert_equal "$(cat ${TMPDIR}bats-zsh)" ""
}

@test "zsource doesn't set \$TMPDIR/project-name if provided a non-executable file" {
     # Given a non-executable file
    file="test/assets/non_executable_main.sh"
    refute [ -x "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then $TMPDIR/bats-zsh should be empty
    assert_equal "$(cat ${TMPDIR}bats-zsh)" ""
}

@test "zsource sets \$TMPDIR/project-name to the provided file's path if it's existing and executable" {
    # Given an existing, executable zsh file
    file="test/assets/main.sh"
    assert [ -x "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then $TMPDIR/bats-zsh should contain to the file's path
    assert_equal "$(cat ${TMPDIR}bats-zsh)" "$file"
}
