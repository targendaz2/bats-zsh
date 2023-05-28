#!/usr/bin/env zsh
# shellcheck source=/dev/null

# Source each file in order
# shellcheck disable=SC2296
zsources=("${(@f)$(<"${BATS_TEST_TMPDIR}/zsource")}")
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
