#!/usr/bin/env zsh

successful_function() {
    return 0
}

failing_function() {
    return 1
}

successful_output_function() {
    echo "This is output"
    return 0
}

failing_output_function() {
    echo "This is a failing command"
    return 1
}

function_with_arg() {
    echo "arg was '$1'"
    return 0
}

function_with_many_args() {
    echo "args were '$3' '$1' '$2'"
    return 0
}

main2_exclusive_function() {
    return 0
}
