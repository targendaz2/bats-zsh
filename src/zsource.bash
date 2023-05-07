zsource() {
    FILE="$1"
    [ ! -f "$FILE" ] && return 1
    export BATS_ZSH_SOURCE="$FILE"
    return 0
}
