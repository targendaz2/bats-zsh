# bats-zsh

![GitHub License](https://img.shields.io/github/license/targendaz2/bats-zsh)
![GitHub package.json version](https://img.shields.io/github/package-json/v/targendaz2/bats-zsh)
![NPM Version](https://img.shields.io/npm/v/bats-zsh?logo=npm&logoColor=%23999999)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/targendaz2/bats-zsh/test.yml?logo=github&label=tests&logoColor=%23999999)

Wrapper enabling [Bats](https://github.com/bats-core/bats-core) to source and test Zsh scripts.

## Install

`npm` is the preferred installation method.

```bash
npm install -D bats-zsh
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
   `yarn install`
4. Run shellcheck:
   `yarn lint`
5. Run tests:
   `yarn test`

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

This package is licensed under the [Creative Commons Zero v1.0 Universal License](https://github.com/targendaz2/bats-zsh/blob/main/LICENSE).
