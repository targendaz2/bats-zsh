#!/usr/bin/env bats

load test_helper
load '../load'

@test "zsource succeeds if provided an existing file" {
    # Given an existing zsh file
    file="test/assets/main.sh"
    assert [ -f "$file" ]

    # When that file is provided to zsource
    run zsource "$file"

    # Then zsource should succeed
    assert_success
}

@test "zsource sets BATS_ZSH_SOURCE if provided an existing file" {
    # Given an existing zsh file
    file="test/assets/main.sh"
    assert [ -f "$file" ]

    # When that file is provided to zsource
    zsource "$file"

    # Then BATS_ZSH_SOURCE should be set to the file's path
    assert_not_equal "$BATS_ZSH_SOURCE" ""
}

@test "zsource sets BATS_ZSH_SOURCE to the provided file's path if the file exists" {
    # Given an existing zsh file
    file="test/assets/main.sh"
    assert [ -f "$file" ]

    # When that file is provided to zsource
    zsource "$file"

    # Then BATS_ZSH_SOURCE should be set to the file's path
    assert_equal "$BATS_ZSH_SOURCE" "$PWD/$file"
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

@test "zsource doesn't set BATS_ZSH_SOURCE if provided a nonexistent file" {
    # Given a nonexistent file
    file="test/assets/fake_zsh_script.sh"
    refute [ -e "$file" ]

    # When that file is provided to zsource
    zsource "$file" || true

    # Then BATS_ZSH_SOURCE should be empty
    assert_equal "$BATS_ZSH_SOURCE" ""
}

@test "zsource fails if provided an empty string" {
    # Given an empty string
    file=''

    # When the empty string is provided to zsource
    run zsource "$file"

    # Then zsource should fail
    assert_failure
}
