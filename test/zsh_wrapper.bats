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
    assert_output 'This is output'
}

@test "sets \$output to command output on failure" {
    # Given the name of a failing function
    func_name='failing_output_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" "$func_name"

    # zsh_wrapper should set $ouput
    assert_output 'This is a failing command'
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
    assert_output 'This is from main2.sh'
}

@test "loads a variable set via zset" {
    zsource 'test/assets/var_funcs.sh'
    var_value=Chris

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "doesn't load a variable not set via zset" {
    zsource 'test/assets/var_funcs.sh'

    # Given a normally set variable
    MY_NAME=Chris

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" whats_my_name

    # Then nothing should be returned
    assert_output ''
}

@test "loads multiple variable set via zset" {
    zsource 'test/assets/var_funcs.sh'
    salutation='Mr.'
    first_name=Chris
    last_name=Smith

    # Given 3 zset variables
    zset SALUTATION "$salutation"
    zset FIRST_NAME "$first_name"
    zset LAST_NAME "$last_name"

    # When a function that includes those variables in its output is called
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" greet_me

    # Then the output should match watch's expected
    assert_output "Hello, $salutation $first_name $last_name!"
}

@test "doesn't fail if no variables are set" {
    zsource 'test/assets/main.sh'

    # Given no variables are set
    :

    # When a successful function is called
    run src/zsh_wrapper.sh "$BATS_ZSH_SOURCE" successful_function

    # Then the command should succeed
    assert_success
}
