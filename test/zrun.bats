#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

load test_helper
load '../load'

@test "zrun fails if \$TMPDIR/project-name isn't set" {
    # Given $TMPDIR/bats-zsh is empty
    assert_equal "$(cat ${TMPDIR}bats-zsh)" ''

    # When zrun is called
    zrun -127 fake_command || true

    # Then zrun should fail
    assert_failure
}

@test "zrun fails if BATS_ZSH_WRAPPER doesn't exist" {
    zsource 'test/assets/main.sh'

    # Given BATS_ZSH_WRAPPER doesn't exist
    BATS_ZSH_WRAPPER='/tmp/fake828282/file.sh'
    refute [ -e "$BATS_ZSH_WRAPPER" ]

    # When zrun is called
    zrun -127 fake_command || true

    # Then zrun should fail
    assert_failure
}

@test "zrun fails if BATS_ZSH_WRAPPER isn't executable" {
    zsource 'test/assets/main.sh'

    # Given BATS_ZSH_WRAPPER isn't an executable file
    BATS_ZSH_WRAPPER='tests/assets/non_executable_zsh_wrapper.sh'
    refute [ -x "$BATS_ZSH_WRAPPER" ]

    # When zrun is called
    zrun -127 fake_command || true

    # Then zrun should fail
    assert_failure
}

@test "zrun doesn't fail if BATS_ZSH_WRAPPER exists and is executable" {
    zsource 'test/assets/main.sh'

    # Given BATS_ZSH_WRAPPER is an existing executable file
    assert [ -x "$BATS_ZSH_WRAPPER" ]

    # When zrun is called
    zrun -127 fake_command || true

    # Then zrun shouldn't fail
    assert_not_equal $status 1
}

@test "zrun fails if provided an empty string" {
    zsource 'test/assets/main.sh'

    # Given an empty string
    command=''

    # When zrun is called with that empty string
    zrun "$command" || true

    # Then zrun should fail
    assert_failure
}

@test "zrun succeeds if the function it runs succeeds" {
    zsource 'test/assets/main.sh'

    # Given the name of a successful function in the zsourced file
    function=successful_function

    # When zrun is called with that function's name
    zrun $function

    # Then zrun should succeed
    assert_success
}

@test "zrun fails if the function it runs fails" {
    zsource 'test/assets/main.sh'

    # Given the name of a failing function in the zsourced file
    function=failing_function

    # When zrun is called with that function's name
    zrun $function

    # Then zrun should fail
    assert_failure
}

@test "zrun captures command output during successes" {
    zsource 'test/assets/main.sh'

    # Given the name of a function that creates output
    function=successful_output_function

    # When zrun is called with that function's name
    zrun $function

    # Then the $output variable should contain that output
    assert_output 'This is output'
}

@test "zrun captures command output during failures" {
    zsource 'test/assets/main.sh'

    # Given the name of a function that creates output
    function=failing_output_function

    # When zrun is called with that function's name
    zrun $function

    # Then the $output variable should contain that output
    assert_output 'This is a failing command'
}

@test "zrun accepts an argument" {
    zsource 'test/assets/main.sh'

    # Given the name of a function that creates output
    function=function_with_arg

    # When zrun is called with that function's name
    zrun $function '1arg'

    # Then the $output variable should contain that output
    assert_output "arg was '1arg'"
}

@test "zrun accepts multiple arguments" {
    zsource 'test/assets/main.sh'

    # Given the name of a function that creates output
    function=function_with_many_args

    # When zrun is called with that function's name
    zrun $function 'arg1' 'arg2' 'arg3'

    # Then the $output variable should contain that output
    assert_output "args were 'arg3' 'arg1' 'arg2'"
}
