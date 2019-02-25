# semver

[![Build Status](https://travis-ci.com/chriskilding/semver.svg?branch=master)](https://travis-ci.com/chriskilding/semver)

Semantic Version parser.

## Overview

A Semantic Version is a version string that conforms to the [Semantic Versioning specification](https://semver.org/).

The general format is:

    major.minor.patch[-prerelease][+build]

Valid examples:

- `0.0.0`
- `1.0.0`
- `1.2.3-alpha`
- `1.2.3+20080101`
- `1.2.3-alpha+20080101`

Invalid examples:

- `v1.0.0`
- `1.0`

The `semver` utility compares, generates, modifies, parses, sorts, and validates these Semantic Version strings.

## Usage

Read the help screen for instructions.

    semver --help

Read the man page for full instructions and examples.

    man semver

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

