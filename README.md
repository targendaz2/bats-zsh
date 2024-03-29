# bats-zsh

![license](https://img.shields.io/github/license/targendaz2/bats-zsh) ![GitHub release](https://img.shields.io/github/package-json/v/targendaz2/bats-zsh?label=release) ![npm](https://img.shields.io/npm/v/bats-zsh) ![tests](https://github.com/targendaz2/bats-zsh/actions/workflows/tests.yml/badge.svg?branch=main)

Wrapper enabling [Bats](https://github.com/bats-core/bats-core) to source and test Zsh scripts.

## Install

`npm` is the preferred installation method.

```bash
npm install bats-zsh
```

## Usage

This project provides the following functions:

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
