# Load dependencies.
BATS_LIB_PATH=$PWD/node_modules:${BATS_LIB_PATH-}
bats_load_library 'bats-support'
bats_load_library 'bats-assert'
