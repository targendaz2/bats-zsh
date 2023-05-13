#!/usr/bin/env zsh
# shellcheck shell=bash

source_script="$1"

shift

source "$source_script"

output=$("$@")
exit_code=$?

echo "$output"

exit $exit_code
