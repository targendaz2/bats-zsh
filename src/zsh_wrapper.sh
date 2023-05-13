#!/usr/bin/env zsh

source_script="$1"

shift

source "$source_script"

output=$(eval "$@")
exit_code=$?

echo "$output"

exit $exit_code
