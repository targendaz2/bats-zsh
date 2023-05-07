#!/usr/bin/env bats

load test_helper
load ../src/zrun
load ../src/zsource

@test "zrun fails if BATS_ZSH_SOURCE isn't set" {
    # Given BATS_ZSH_SOURCE isn't set
    assert_equal "$BATS_ZSH_SOURCE" ''

    # When zrun is called
    run zrun 'fake_command'

    # Then zrun should fail
    assert_failure
}

@test "zrun succeeds if BATS_ZSH_SOURCE is set by zsource" {
    # Given BATS_ZSH_SOURCE is set by zsource
    zsource 'test/assets/main.sh'

    # When zrun is called
    run zrun 'fake_command'

    # Then zrun should succeed
    assert_success
}

@test "zrun fails if provided an empty string" {
    zsource 'test/assets/main.sh'

    # Given an empty string
    command=''

    # When zrun is called with that empty string
    run zrun "$command"

    # Then zrun should fail
    assert_failure
}
