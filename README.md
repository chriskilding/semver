# semver

[![Build Status](https://travis-ci.com/chriskilding/semver.svg?branch=master)](https://travis-ci.com/chriskilding/semver)

Semantic Version parser.

## What is a Semantic Version?

A Semantic Version is a version string that conforms to the [Semantic Versioning specification](https://semver.org/).

The general format is:

    major.minor.patch[-prerelease][+build]

### Valid examples

- `0.0.0`
- `1.0.0`
- `1.2.3-alpha`
- `1.2.3+20080101`
- `1.2.3-alpha+20080101`

### Invalid examples

- `v1.0.0`
- `1`
- `1.0`
- `1.0.0.0`

## Usage

Read the help screen for instructions.

```
semver --help
```

**Note:** `semver compare` compares versions according to the Semantic Versioning [precedence specification](https://semver.org/#spec-item-11). This is **not** a simple lexicographic comparison! For example, `0.0.1+foo` equals `0.0.1+bar` under Semantic Versioning precedence rules.

## Dependencies

- [Perl](http://www.perl.org) 5+ (pre-installed on: macOS, Debian, openSUSE)
- [Bats](https://github.com/bats-core/bats-core) (test)
- [Shellcheck](https://github.com/koalaman/shellcheck) (test)

## Install

1. Download the `semver` script from the repository somehow.
2. Place it anywhere on your `$PATH`.

## Test

```bash
make test
```

