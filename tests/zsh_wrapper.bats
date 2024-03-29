#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

load test_helper
load '../src/zsource'
load '../src/zset'

setup() {
    BATS_ZSH_SOURCE="${BATS_TEST_TMPDIR}/zsource"
    echo 'tests/assets/main.sh' > "$BATS_ZSH_SOURCE"
    echo 'tests/assets/var_funcs.sh' >> "$BATS_ZSH_SOURCE"

    BATS_ZSH_VARS="${BATS_TEST_TMPDIR}/zset"
}

@test "sets \$status to command exit code on success" {
    # Given the name of a successful function
    func_name='successful_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh "$func_name"

    # zsh_wrapper should set $status to 0
    assert_equal $status 0
}

@test "sets \$status to command exit code on failure" {
    # Given the name of a failing function
    func_name='failing_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh "$func_name"

    # zsh_wrapper should set $status to 1
    assert_equal $status 1
}

@test "sets \$output to command output on success" {
    # Given the name of a successful function
    func_name='successful_output_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh "$func_name"

    # zsh_wrapper should set $ouput
    assert_equal "$output" 'This is output'
}

@test "sets \$output to command output on failure" {
    # Given the name of a failing function
    func_name='failing_output_function'

    # When that function name is provided to zsh_wrapper
    run src/zsh_wrapper.sh "$func_name"

    # zsh_wrapper should set $ouput
    assert_equal "$output" 'This is a failing command'
}

@test "succeeds for funcs in only the last sourced file" {
    # Given 2 zsourced files...
    zsource 'tests/assets/main.sh'
    zsource 'tests/assets/main2.sh'

    # ...And a function that only exists in the last
    function=main2_exclusive_function

    # When the wrapper is called with that function's name
    run src/zsh_wrapper.sh $function

    # Then the command should succeed
    assert_success
}

@test "succeeds for funcs in only the 1st sourced file" {
    # Given 2 zsourced files...
    zsource 'tests/assets/main.sh'
    zsource 'tests/assets/main2.sh'

    # ...And a function that only exists in the last
    function=main_exclusive_function

    # When the wrapper is called with that function's name
    run src/zsh_wrapper.sh $function

    # Then the command should succeed
    assert_success
}

@test "if multiple funcs with the same name are sourced, only the newest one is used" {
    # Given 2 zsourced files...
    zsource 'tests/assets/main.sh'
    zsource 'tests/assets/main2.sh'

    # ...And a function that exists in both
    function=shared_function

    # When the wrapper is called with that function's name
    run src/zsh_wrapper.sh $function

    # Then the newest version of that function should run
    assert_output 'This is from main2.sh'
}

@test "loads a variable set via zset" {
    var_value=Chris

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "doesn't load a variable not set via zset" {

    # Given a normally set variable
    MY_NAME=Chris

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then nothing should be returned
    assert_output ''
}

@test "loads multiple variables set via zset" {
    salutation='Mr.'
    first_name=Chris
    last_name=Smith

    # Given 3 zset variables
    zset SALUTATION "$salutation"
    zset FIRST_NAME "$first_name"
    zset LAST_NAME "$last_name"

    # When a function that includes those variables in its output is called
    run src/zsh_wrapper.sh greet_me

    # Then the output should match watch's expected
    assert_output "Hello, $salutation $first_name $last_name!"
}

@test "doesn't fail if no variables are set" {
    zsource 'tests/assets/main.sh'

    # Given no variables are set
    :

    # When a successful function is called
    run src/zsh_wrapper.sh successful_function

    # Then the command should succeed
    assert_success
}

@test "can handle variables with spaces in them" {
    var_value='Chris Smith'

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "can handle variables with single quotes in them" {
    var_value="Chris O'Smith"

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "can handle variables with double quotes in them" {
    var_value='Chris "Oreo" Smith'

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "can handle variables with parenthesis in them" {
    var_value='Chris (Oreo) Smith'

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "can handle variables with square brackets in them" {
    var_value='Chris [Oreo] Smith'

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "can handle variables with curly brackets in them" {
    var_value='Chris {Oreo} Smith'

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "can handle variables with dollar signs in them" {
    var_value='Chris "$bills" Smith'

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "can handle variables with back slashes in them" {
    var_value='Chris "\usr\local\bin" Smith'

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}

@test "can handle variables with forward slashes in them" {
    var_value='Chris Smith/Smithy'

    # Given a zset variable
    zset MY_NAME "$var_value"

    # When a function that returns that variable is called
    run src/zsh_wrapper.sh whats_my_name

    # Then the variable value should be returned
    assert_output "$var_value"
}
