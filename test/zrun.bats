#!/usr/bin/env bats

load test_helper
load ../src/zrun
load ../src/zsource

@test "zrun fails if BATS_ZSH_SOURCE isn't set" {
    # Given BATS_ZSH_SOURCE isn't set
    assert_equal "$BATS_ZSH_SOURCE" ''

    # When zrun is called
    run zrun 

    # Then zrun should fail
    assert_failure
}
