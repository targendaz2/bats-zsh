#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

load test_helper

@test "sets \$status to command exit code on success" {
    # Given the name of a successful function
    func_name='successful_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh test/assets/main.sh "$func_name"

    # zsh_wrapper should set $status to 0
    assert_equal $status 0
}

@test "sets \$status to command exit code on failure" {
    # Given the name of a failing function
    func_name='failing_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh test/assets/main.sh "$func_name"

    # zsh_wrapper should set $status to 1
    assert_equal $status 1
}

@test "sets \$output to command output on success" {
    # Given the name of a successful function
    func_name='successful_output_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh test/assets/main.sh "$func_name"

    # zsh_wrapper should set $ouput
    assert_equal "$output" 'This is output'
}

@test "sets \$output to command output on failure" {
    # Given the name of a failing function
    func_name='failing_output_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh test/assets/main.sh "$func_name"

    # zsh_wrapper should set $ouput
    assert_equal "$output" 'This is a failing command'
}
