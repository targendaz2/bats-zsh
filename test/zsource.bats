#!/usr/bin/env bats

load test_helper
load ../src/zsource

@test "zsource sets BATS_ZSH_SOURCE if provided an existing file" {
    # Given an existing zsh file
    file='test/assets/main.sh'
    assert [ -f "$file" ]

    # When that file is provided to zsource
    zsource "$file"

    # Then BATS_ZSH_SOURCE should be set to the file's path
    assert_not_equal "$BATS_ZSH_SOURCE" ""
}

@test "zsource sets BATS_ZSH_SOURCE to the provided file's path if the file exists" {
    # Given an existing zsh file
    file='test/assets/main.sh'
    assert [ -f "$file" ]

    # When that file is provided to zsource
    zsource "$file"

    # Then BATS_ZSH_SOURCE should be set to the file's path
    assert_equal "$BATS_ZSH_SOURCE" "$file"
}
