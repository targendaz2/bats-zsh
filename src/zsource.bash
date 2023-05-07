zsource() {
    FILE="$1"
    export BATS_ZSH_SOURCE="$FILE"
    return 0
}
