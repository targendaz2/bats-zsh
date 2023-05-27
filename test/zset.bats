#!/usr/bin/env bats

load test_helper
load '../load'

@test "zset fails if provided an empty string as the variable name" {
    # Given an empty variable name
    variable_name=''

    # When the empty string is provided to zset
    run zset "$variable_name"

    # Then zset should fail
    assert_failure
}

@test "zset succeeds if not provided a variable value" {
    # Given an empty variable value
    variable_value=''

    # When the invalid assignment is provided to zset
    run zset variable_name "$variable_value"

    # Then zset should succeed
    assert_success
}

@test "zset succeeds if provided a variable value" {
    # Given an empty variable value
    variable_value='value'

    # When the invalid assignment is provided to zset
    run zset variable_name "$variable_value"

    # Then zset should succeed
    assert_success
}

@test "zset writes a valid name and value to ${BATS_TEST_TMPDIR}/zset" {
    # Given a valid variable name and value
    variable_name='my_variable'
    variable_value='my_value'

    # When the invalid assignment is provided to zset
    run zset "$variable_name" "$variable_value"

    # Then that variable assignment should be in ${BATS_TEST_TMPDIR}/zset
    zset_content="$(cat ${BATS_TEST_TMPDIR}/zset)"
    assert_equal "$zset_content" "$variable_name=$variable_value"
}

@test "zset doesn't write an to ${BATS_TEST_TMPDIR}/zset if provided an empty variable name but not value" {
    # Given an empty variable name and a value
    variable_name=''
    variable_value='my_value'

    # When the invalid assignment is provided to zset
    run zset "$variable_name" "$variable_value"

    # Then the zset file shouldn't exist
    assert [ ! -f ${BATS_TEST_TMPDIR}/zset ]
}
