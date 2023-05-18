BATS_ZSH_WRAPPER="$(dirname "${BASH_SOURCE[0]}")/zsh_wrapper.sh"

zrun() {
    # BATS_ZSH_SOURCE checks
    if [ -z "$(cat "$BATS_ZSH_SOURCE")" ]; then
        echo 'You must source a script with zsource before calling zrun' | \
        batslib_decorate 'zrun failed' | \
        fail
    fi

    # BATS_ZSH_WRAPPER checks
    if [ ! -e "$BATS_ZSH_WRAPPER" ]; then
        echo 'zsh_wrapper.sh was moved or deleted' | \
        batslib_decorate 'zrun failed' | \
        fail
    fi

    if [ ! -x "$BATS_ZSH_WRAPPER" ]; then
        echo 'zsh_wrapper.sh must be executable' | \
        batslib_decorate 'zrun failed' | \
        fail
    fi

    # Argument checks
    if [ -z "$1" ]; then
        echo 'zrun cannot be called without arguments' | \
        batslib_decorate 'zrun failed' | \
        fail
    fi

    # Handle the -127 argument
    run_cmd='run'
    if [ "$1" = '-127' ]; then
        run_cmd+=' -127'
        shift
    fi

    # Run the command
    $run_cmd "$BATS_ZSH_WRAPPER" "$BATS_ZSH_SOURCE" "$@"

    # Don't fail so the tests can run
    return 0
}
