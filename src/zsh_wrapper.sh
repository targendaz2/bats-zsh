#!/usr/bin/env zsh
# shellcheck shell=bash

# Get the name of the file to parse for sources from arg 1
# shellcheck source=/dev/null
zsource_file="$1"
shift

# Source each file in order
# shellcheck disable=SC2296
zsources=("${(@f)$(<"$zsource_file")}")
for zsh_script in "${zsources[@]}"; do
    source "$zsh_script"
done

# Source any set variables
bats_zsh_vars="${BATS_TEST_TMPDIR}/zset"
[ -f "$bats_zsh_vars" ] && source "$bats_zsh_vars"

output=$("$@")
exit_code=$?

echo "$output"

exit $exit_code
