#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

load test_helper

@test "fails if provided script doesn't exist" {
    # Given a path to a non-existent script
    script_path='test/assets/nonexistent_script.sh'

    # When that script is provided to zsh_wrapper
    run -127 zsh_wrapper.sh "$script_path"

    # zsh_wrapper should fail
    assert_failure
}

@test "fails if provided script isn't executable" {
    # Given a path to a non-existent script
    script_path='test/assets/non_executable_zsh_wrapper.sh'

    # When that script is provided to zsh_wrapper
    run -127 zsh_wrapper.sh "$script_path"

    # zsh_wrapper should fail
    assert_failure
}
