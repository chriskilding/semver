# semver

[![Build Status](https://travis-ci.com/chriskilding/semver.svg?branch=master)](https://travis-ci.com/chriskilding/semver)
[![Codecov](https://codecov.io/gh/chriskilding/semver/branch/master/graph/badge.svg)](https://codecov.io/gh/chriskilding/semver)

Semantic Versioning utility.

## Overview

The `semver` command line utility compares, generates, modifies, parses, sorts, and validates [Semantic Version](https://semver.org/) strings.

The Semantic Versioning format is:

    major.minor.patch[-prerelease][+build]

Examples: `1.2.3`, `1.2.3-alpha`, `1.2.3+2008`, `1.2.3-alpha+2008`.

## Install

Dependencies:

- [Perl](http://www.perl.org) 5+ (pre-installed on: macOS, Debian, openSUSE)
- [Bats](https://github.com/bats-core/bats-core) (test)

### Source

```bash
$ make
$ make test # optional
$ make install
```

### Homebrew

Coming soon.

## Usage

    semver get [--major | --minor | --patch | --prerelease | --build] <version>
    semver grep -

Subcommands:

    semver-compare [-h] <version> <version>
    semver-decrement [ --major | --minor | --patch ] <version>
    semver-increment [--major | --minor | --patch] <version>
    semver-sort [-hr] -
    semver-validate [-h] <string>

Man page:

```bash
$ man semver
```
