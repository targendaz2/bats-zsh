#!/usr/bin/env bats

load test_helper
load ../src/zrun
load ../src/zsource

bats_require_minimum_version 1.5.0

@test "zrun fails if provided an empty string" {
    zsource 'test/assets/main.sh'

    # Given an empty string
    command=''

    # When zrun is called with that empty string
    run zrun "$command"

    # Then zrun should fail
    assert_failure
}

@test "zrun fails if BATS_ZSH_SOURCE isn't set" {
    # Given BATS_ZSH_SOURCE isn't set
    assert_equal "$BATS_ZSH_SOURCE" ''

    # When zrun is called
    run zrun 'fake_command'

    # Then zrun should fail
    assert_failure
}

@test "zrun doesn't fail if BATS_ZSH_SOURCE is set by zsource" {
    # Given BATS_ZSH_SOURCE is set by zsource
    zsource 'test/assets/main.sh'

    # When zrun is called
    run -127 zrun 'fake_command'

    # Then zrun shouldn't fail
    assert_not_equal $status 1
}

@test "zrun fails if BATS_ZSH_SOURCE doesn't exist" {
    # Given BATS_ZSH_SOURCE doesn't exist
    source_file='test/assets/nonexistent_main.sh'
    run [ -e "$source_file" ]
    assert_failure
    run zsource "$source_file"

    # When zrun is called
    run zrun 'fake_command'

    # Then zrun should fail
    assert_failure
}

@test "zrun fails if BATS_ZSH_SOURCE isn't executable" {
    # Given BATS_ZSH_SOURCE isn't executable
    source_file='test/assets/nonexicutable_main.sh'
    run [ -x "$source_file" ]
    assert_failure
    run zsource "$source_file"

    # When zrun is called
    run zrun 'fake_command'

    # Then zrun should fail
    assert_failure
}

@test "zrun fails if BATS_ZSH_WRAPPER doesn't exist" {
    zsource 'test/assets/main.sh'

    # Given BATS_ZSH_WRAPPER doesn't exist
    BATS_ZSH_WRAPPER='/tmp/fake828282/file.sh'
    run [ -e "$BATS_ZSH_WRAPPER" ]
    assert_failure

    # When zrun is called
    run zrun 'fake_command'

    # Then zrun should fail
    assert_failure
}

@test "zrun fails if BATS_ZSH_WRAPPER isn't executable" {
    zsource 'test/assets/main.sh'

    # Given BATS_ZSH_WRAPPER isn't an executable file
    BATS_ZSH_WRAPPER='tests/assets/non_executable_zsh_wrapper.sh'
    run [ -x "$BATS_ZSH_WRAPPER" ]
    assert_failure

    # When zrun is called
    run zrun 'fake_command'

    # Then zrun should fail
    assert_failure
}

@test "zrun doesn't fail if BATS_ZSH_WRAPPER is executable" {
    zsource 'test/assets/main.sh'

    # Given BATS_ZSH_WRAPPER is an executable file
    run [ -x "$BATS_ZSH_WRAPPER" ]
    assert_success

    # When zrun is called
    run -127 zrun 'fake_command'

    # Then zrun shouldn't fail
    assert_not_equal $status 1
}

@test "zrun succeeds if the function it runs succeeds" {
    zsource 'test/assets/main.sh'

    # Given the name of a successful function in the zsourced file
    function=successful_function

    # When zrun is called with that function's name
    run zrun $function

    # Then zrun should succeed
    assert_success
}

@test "zrun fails if the function it runs fails" {
    zsource 'test/assets/main.sh'

    # Given the name of a failing function in the zsourced file
    function=failing_function

    # When zrun is called with that function's name
    run zrun $function

    # Then zrun should fail
    assert_failure
}

@test "zrun captures command output during successes" {
    zsource 'test/assets/main.sh'

    # Given the name of a function that creates output
    function=successful_output_function

    # When zrun is called with that function's name
    run zrun $function

    # Then the $output variable should contain that output
    assert_equal "$output" "This is output"
}

@test "zrun captures command output during failures" {
    zsource 'test/assets/main.sh'

    # Given the name of a function that creates output
    function=failing_output_function

    # When zrun is called with that function's name
    run zrun $function

    # Then the $output variable should contain that output
    assert_equal "$output" "This is a failing command"
}
