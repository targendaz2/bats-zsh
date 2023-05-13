BATS_ZSH_WRAPPER="$(dirname "${BASH_SOURCE[0]}")/zsh_wrapper.sh"

zrun() {
    CMD="$1"

    [ -z "$CMD" ] && return 1
    [ -z "$BATS_ZSH_SOURCE" ] && return 1
    [ ! -x "$BATS_ZSH_WRAPPER" ] && return 1

    "$BATS_ZSH_WRAPPER" "$BATS_ZSH_SOURCE" "$@"
    return_code=$?
    return $return_code
}
