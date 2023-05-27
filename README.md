# bats-zsh

![license](https://img.shields.io/github/license/targendaz2/bats-zsh?label=License) ![GitHub release](https://img.shields.io/github/package-json/v/targendaz2/bats-zsh?label=Release) ![tests](https://github.com/targendaz2/bats-zsh/actions/workflows/tests.yml/badge.svg?branch=main)

Wrapper enabling [Bats](https://github.com/bats-core/bats-core) to source and test Zsh scripts.

## Install

The preferred installation method is via `npm`:

```bash
npm install github:targendaz2/bats-zsh
```

## Usage

This project provides the following functions:

### `zsource`

Used in place of `source` to source 1 or more Zsh files.

```bash
@test 'zsource sample test'{
    zsource path/to/zsh-file1.sh
    zsource path/to/zsh-file2.sh
}
```

When multiple files are sourced using `zsource`, conflicts will be handled the same as `source` would. In effect, when there is a conflict, the newer version will overwrite the older one.

### `zrun`

Used in place of `run` to run a function from the sourced Zsh script.

```bash
@test 'output_number_of_args() outputs the number of args' {
    zsource path/to/zsh-file.sh
    zrun output_number_of_args arg1 arg2 arg3

    [ "$status" -eq 0 ]
    [ "$output" = "there were 3 args" ]
    [ "$BATS_RUN_COMMAND" = "zrun output_number_of_args arg1 arg2 arg3" ]
}
```

All variables expected from `run` will be set (i.e. `status`, `output`, and `BATS_RUN_COMMAND`).

### `zset`

Used to set or change global variables in the sourced files.

```bash
@test 'say_my_name() outputs \$MY_NAME'{
    zsource path/to/zsh-file.sh

    zrun say_my_name

    [ "$output" = "You don't have a name" ]

    zset MY_NAME="David"

    zrun say_my_name

    [ "$output" = "Your name is David" ]
}
```

### Testing

1. Clone this repository:
`git clone https://github.com/targendaz2/bats-zsh.git`
2. Install global dependencies:
[Node.js](https://nodejs.org/en/download/package-manager), [ShellCheck](https://github.com/koalaman/shellcheck#user-content-installing), & [Zsh](https://nodejs.org/en/download/package-manager)
3. Install project dependencies:
`npm install`
4. Run shellcheck:
`npm run shellcheck`
5. Run tests:
`npm test test`
