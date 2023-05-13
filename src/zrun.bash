BATS_ZSH_WRAPPER="$(dirname "${BASH_SOURCE[0]}")/zsh_wrapper.sh"

zrun() {
    if [ -z "$BATS_ZSH_SOURCE" ]; then
        echo 'You must source a script with zsource before calling zrun' | \
        batslib_decorate 'zrun failed' | \
        fail
    fi

    if [ ! -e "$BATS_ZSH_SOURCE" ]; then
        echo "The sourced script does not exist" | \
        batslib_decorate 'zrun failed' | \
        fail
    fi

    if [ -z "$1" ]; then
        echo 'zrun cannot be called without arguments' | \
        batslib_decorate 'zrun failed' | \
        fail
    fi

    run_cmd='run'
    if [ "$1" = '-127' ]; then
        run_cmd+=' -127'
        shift
    fi
    $run_cmd "$BATS_ZSH_WRAPPER" "$BATS_ZSH_SOURCE" "$@"

    return 0
}
