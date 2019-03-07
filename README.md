# semver

[![Build Status](https://travis-ci.com/chriskilding/semver.svg?branch=master)](https://travis-ci.com/chriskilding/semver)
[![Codecov](https://codecov.io/gh/chriskilding/semver/branch/master/graph/badge.svg)](https://codecov.io/gh/chriskilding/semver)

Semantic Versioning utility.

## Overview

A Semantic Version is a version string that conforms to the [Semantic Versioning specification](https://semver.org/).

The general format is:

    major.minor.patch[-prerelease][+build]

Valid examples:

- `0.0.0`
- `1.0.0`
- `1.2.3-alpha`
- `1.2.3+2008`
- `1.2.3-alpha+2008`

Invalid examples:

- `v1.0.0`
- `1.0`

The `semver` utility compares, generates, modifies, parses, sorts, and validates these Semantic Version strings.

## Usage

Read the help screen for reference:

```bash
$ semver --help
```
    
    Usage:
      semver compare <version> <version>
      semver decrement-major <version>
      semver decrement-minor <version>
      semver decrement-patch <version>
      semver get-major <version>
      semver get-minor <version>
      semver get-patch <version>
      semver get-prerelease <version>
      semver get-build <version>
      semver grep -
      semver increment-major <version>
      semver increment-minor <version>
      semver increment-patch <version>
      semver init
      semver sort [-r | --reverse] -
      semver validate <string>
      semver [-h | --help]
    
    Options:
      -h --help  Show this help screen.

Read the man page for full instructions and examples:

```bash
$ man semver
```

## Dependencies

- [Perl](http://www.perl.org) 5+ (pre-installed on: macOS, Debian, openSUSE)
- [Bats](https://github.com/bats-core/bats-core) (test)

## Install

```bash
$ make install
```

## Test

```bash
$ make test
```

