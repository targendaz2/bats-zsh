#!/usr/bin/env bats

load test_helper
load '../load'

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

    # Then BATS_ZSH_SOURCE should be set to the file's path
    assert_success
}

@test "zsource doesn't set BATS_ZSH_SOURCE if provided an empty string" {
    # Given an empty string
    file=''

    # When the empty string is provided to zsource
    zsource "$file" || true

    # Then BATS_ZSH_SOURCE should be empty
    assert_equal "$BATS_ZSH_SOURCE" ""
}

@test "zsource doesn't set BATS_ZSH_SOURCE if provided a non-existent file" {
    # Given a nonexistent file
    file="test/assets/fake_zsh_script.sh"
    refute [ -e "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then BATS_ZSH_SOURCE should be empty
    assert_equal "$BATS_ZSH_SOURCE" ""
}

@test "zsource doesn't set BATS_ZSH_SOURCE if provided a non-executable file" {
     # Given a non-executable file
    file="test/assets/non_executable_main.sh"
    refute [ -x "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then BATS_ZSH_SOURCE should be empty
    assert_equal "$BATS_ZSH_SOURCE" ""
}

@test "zsource sets BATS_ZSH_SOURCE to the provided file's path if it's existing and executable" {
    # Given an existing, executable zsh file
    file="test/assets/main.sh"
    assert [ -x "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then BATS_ZSH_SOURCE should be set to the file's path
    assert_equal "$BATS_ZSH_SOURCE" "$file"
}
