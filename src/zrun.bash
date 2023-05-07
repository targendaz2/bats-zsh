zrun() {
    local DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    run "$DIR/zsh_wrapper.sh" "$@"
}
