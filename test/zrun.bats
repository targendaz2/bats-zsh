#!/usr/bin/env bats

load test_helper
load ../src/zrun
load ../src/zsource

bats_require_minimum_version 1.5.0

@test "zrun fails if BATS_ZSH_SOURCE isn't set" {
    # Given BATS_ZSH_SOURCE isn't set
    assert_equal "$BATS_ZSH_SOURCE" ''

    # When zrun is called
    run zrun 'fake_command'

    # Then zrun should fail
    assert_failure
}

@test "zrun fails if BATS_ZSH_WRAPPER isn't set" {
    zsource 'test/assets/main.sh'

    # Given BATS_ZSH_WRAPPER isn't set
    BATS_ZSH_WRAPPER=''
    assert_equal "$BATS_ZSH_WRAPPER" ''

    # When zrun is called
    run -127 zrun 'fake_command'

    # Then zrun should fail
    assert_failure
}

@test "zrun succeeds if BATS_ZSH_SOURCE is set by zsource" {
    skip
    # Given BATS_ZSH_SOURCE is set by zsource
    zsource 'test/assets/main.sh'

    # When zrun is called
    run zrun 'fake_command'

    # Then zrun should succeed
    assert_success
}

@test "zrun fails if provided an empty string" {
    skip
    zsource 'test/assets/main.sh'

    # Given an empty string
    command=''

    # When zrun is called with that empty string
    run zrun "$command"

    # Then zrun should fail
    assert_failure
}

@test "zrun succeeds if the function it runs succeeds" {
    skip
    zsource 'test/assets/main.sh'

    # Given the name of a function in the zsourced file
    function=successful_function

    # When zrun is called with that function's name
    run zrun $function

    # Then zrun should succeed
    assert_success
}

@test "zrun fails if the function it runs fails" {
    skip
    zsource 'test/assets/main.sh'

    # Given the name of a function in the zsourced file
    function=failing_function

    # When zrun is called with that function's name
    run zrun $function

    # Then zrun should succeed
    assert_failure
}
