copy_function() {
    declare -F "$1" > /dev/null || return 1
    eval "$(echo "${2}()"; declare -f "$1" | tail -n +2)"
}

copy_function "run" "bats_run"

run() {
    zrun "$1"
}
