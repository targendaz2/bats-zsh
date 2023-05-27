BATS_ZSH_VARS="${BATS_TEST_TMPDIR}/zset"

zset() {
    local VAR_NAME="$1"
    local VAR_VALUE="$2"

    if [ -z "$VAR_NAME" ]; then
        echo "zset must be called with a variable name"
        return 1
    fi

    # Escape backslashes
    VAR_VALUE="$(sed 's/\\/\\\\\\\\\\\\\\\\/g' <<< "$VAR_VALUE")"

    # Escape other problematic characters
    VAR_VALUE="$(sed -r "s/([ '\"$])/\\\\\1/g" <<< "$VAR_VALUE")"
    
    echo "$VAR_NAME=$VAR_VALUE" >> "$BATS_ZSH_VARS"
    cat "$BATS_ZSH_VARS"
    return 0
}
