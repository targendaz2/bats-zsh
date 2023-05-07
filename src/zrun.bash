zrun() {
    CMD="$1"
    [ -z "$CMD" ] && return 1
    [ -z "$BATS_ZSH_SOURCE" ] && return 1
    return 0
}
