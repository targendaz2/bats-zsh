BATS_ZSH_VARS="${BATS_TEST_TMPDIR}/zset"

zset() {
    local VAR_NAME="$1"
    local VAR_VALUE="$2"

    if [ -z "$VAR_NAME" ]; then
        echo "zset must be called with a variable name"
        return 1
    fi

    echo "$VAR_NAME=$VAR_VALUE" >> "$BATS_ZSH_VARS"
    return 0
}
