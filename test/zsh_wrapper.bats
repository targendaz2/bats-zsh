#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

load test_helper
load '../src/zsource'
load '../src/zset'

setup() {
    BATS_ZSH_SOURCE="${BATS_TEST_TMPDIR}/zsource"
    echo 'test/assets/main.sh' > "$BATS_ZSH_SOURCE"
}

@test "sets \$status to command exit code on success" {
    # Given the name of a successful function
    func_name='successful_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" "$func_name"

    # zsh_wrapper should set $status to 0
    assert_equal $status 0
}

@test "sets \$status to command exit code on failure" {
    # Given the name of a failing function
    func_name='failing_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" "$func_name"

    # zsh_wrapper should set $status to 1
    assert_equal $status 1
}

@test "sets \$output to command output on success" {
    # Given the name of a successful function
    func_name='successful_output_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" "$func_name"

    # zsh_wrapper should set $ouput
    assert_equal "$output" 'This is output'
}

@test "sets \$output to command output on failure" {
    # Given the name of a failing function
    func_name='failing_output_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" "$func_name"

    # zsh_wrapper should set $ouput
    assert_equal "$output" 'This is a failing command'
}

@test "succeeds for funcs in only the last sourced file" {
    # Given 2 zsourced files...
    zsource 'test/assets/main.sh'
    zsource 'test/assets/main2.sh'

    # ...And a function that only exists in the last
    function=main2_exclusive_function

    # When the wrapper is called with that function's name
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" $function

    # Then the command should succeed
    assert_success
}

@test "succeeds for funcs in only the 1st sourced file" {
    # Given 2 zsourced files...
    zsource 'test/assets/main.sh'
    zsource 'test/assets/main2.sh'

    # ...And a function that only exists in the last
    function=main_exclusive_function

    # When the wrapper is called with that function's name
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" $function

    # Then the command should succeed
    assert_success
}

@test "if multiple funcs with the same name are sourced, only the newest one is used" {
    # Given 2 zsourced files...
    zsource 'test/assets/main.sh'
    zsource 'test/assets/main2.sh'

    # ...And a function that exists in both
    function=shared_function

    # When the wrapper is called with that function's name
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" $function

    # Then the newest version of that function should run
    assert_output "$output" "This is from main2.sh"
}
