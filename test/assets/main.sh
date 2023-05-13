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
