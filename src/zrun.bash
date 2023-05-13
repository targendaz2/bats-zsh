BATS_ZSH_WRAPPER="$(dirname "${BASH_SOURCE[0]}")/zsh_wrapper.sh"

zrun() {
    run_cmd='run'
    if [ "$1" = '-127' ]; then
        run_cmd+=' -127'
        shift
    fi
    $run_cmd "$BATS_ZSH_WRAPPER" "$BATS_ZSH_SOURCE" "$@"
}
