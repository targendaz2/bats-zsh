zsource() {
    local FILE="$1"

    if [ -z "$FILE" ]; then
        echo "zsource must be called with a script's path"
        return 1
    fi

    if [ ! -f "$FILE" ]; then
        echo "Script \`$FILE\` does not exist"
        return 1
    fi

    if [ ! -x "$FILE" ]; then
        echo "Script \`$FILE\` is not executable"
        return 1
    fi
    
    export BATS_ZSH_SOURCE="$FILE"
    return 0
}
