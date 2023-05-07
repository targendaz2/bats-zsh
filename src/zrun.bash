zrun() {
    [ -z "$BATS_ZSH_SOURCE" ] && return 1
    return 0
}
