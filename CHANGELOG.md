# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.2.1]

### Changed

- The `zsource` cache path is no longer passed to `zsh_wrapper.sh`.
- `zsh_wrapper.sh` generates the cache path on its own.
- `zrun` supports the full range of expected return codes supported by `run`.

## [v1.2.0]

### Added

- `zset` command. Used to set variables called by the functions called by `zrun`.

### Changed

- Added `zset` command and examples to the readme.

### Fixed

- `zrun` tests now use `assert_output` to test command output.

## [v1.1.0]

### Added

- Multiple files can be sourced with `zsource`.

### Changed

- `zsource` uses a temporary file instead of an environment variable.

## [v1.0.2]

### Added

- `zsource` and `zrun` commands output descriptive errors.

### Fixed

- `zrun` tests no longer use `run` (i.e. `run` was called inside itself).

## [v1.0.1]

### Added

- `zrun` accepts the `-127` argument from `run`.

### Fixed

- `zrun` calls `run` internally.
- `zrun` no longer specifically checks arg 1, `zsource`, or the `zsh_wrapper.sh` path.

## [v1.0.0]

### Added

- Source zsh files with `zsource`.
- Run functions from the sourced zsh file with `zrun`.

[v1.2.0]: <https://github.com/targendaz2/bats-zsh/compare/v1.1.0...v1.2.0>
[v1.1.0]: <https://github.com/targendaz2/bats-zsh/compare/v1.0.2...v1.1.0>
[v1.0.2]: <https://github.com/targendaz2/bats-zsh/compare/v1.0.1...v1.0.2>
[v1.0.1]: <https://github.com/targendaz2/bats-zsh/compare/v1.0.0...v1.0.1>
[v1.0.0]: <https://github.com/targendaz2/bats-zsh/releases/tag/v1.0.0>
