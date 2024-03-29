#!/usr/bin/env bats

load test_helper
load '../src/zsource'

@test "bats run command calls zrun when overridden" {
    load '../src/zrun'
    zsource 'tests/assets/main.sh'

    run type run
    assert_output --partial "bats_interrupt_trap"

    load '../src/overrides/run'

    bats_run type run
    assert_output --partial "zrun"
}

@test "source builtin is overridden" {
    run type source
    assert_output --partial "shell builtin"

    load '../src/overrides/source'

    run type source
    assert_output --partial "function"
}

@test "source function calls zsource when overriden" {
    load '../src/overrides/source'

    assert [ ! -e "$BATS_ZSH_SOURCE" ]

    source_file="tests/assets/main.sh"
    run source "$source_file"

    run cat "$BATS_ZSH_SOURCE"
    assert_output --partial "$source_file"
}
