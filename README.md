# semver

[![Build Status](https://travis-ci.com/chriskilding/semver.svg?branch=master)](https://travis-ci.com/chriskilding/semver)
[![Codecov](https://codecov.io/gh/chriskilding/semver/branch/master/graph/badge.svg)](https://codecov.io/gh/chriskilding/semver)

Semantic Versioning utility.

## Overview

The `semver` command line utility and functions generate, modify, parse, sort, and validate [Semantic Version](https://semver.org/) strings.

The Semantic Versioning format is:

    major.minor.patch[-prerelease][+build]

Examples: `1.2.3`, `1.2.3-alpha`, `1.2.3+2008`, `1.2.3-alpha+2008`.

## Install

Dependencies:

- [Perl](http://www.perl.org) 5+ (pre-installed on: macOS, Debian, openSUSE)
- [Bats](https://github.com/bats-core/bats-core) (test)
- [ShellCheck](https://github.com/koalaman/shellcheck) (test)

### Source

```bash
$ make
$ make test # optional
$ make install
```

### Homebrew

Coming soon.

## Usage

semver:

```bash
semver grep [-coq] -
semver printf <format> <version>
semver sort [-r] -
semver [-h]
```

semver.sh:

```bash
. semver.sh

++major <version>
++minor <version>
++patch <version>
```

## Manual

semver:

```bash
man semver
```

semver.sh:

```bash
man 3 semver
```

## Examples

Find the current Git tag:

```bash
git tag | semver grep -o | semver sort -r | head -n 1
```    

Validate a candidate version string:

```bash
[[ $(semver grep -q <<< "1.2.3-alpha+1") ]] && echo "Valid"
```

Format a list of version strings as CSV:

```bash
git tag | semver grep -o | xargs semver printf "%major,%minor,%patch,%prerelease,%build" {}
```

Download all artifacts in a version range (requires `semver(3)` shell functions):

```bash
version="0.0.1"
while curl -fs "https://example.com/artifact/$version.tar.gz" > "$version.tar.gz"; do
    version=$(++patch "$version")
done
```

Increment the current Git tag (requires `semver(3)` shell functions):

```bash
++patch $(git tag | semver grep -o | semver sort -r | head -n 1)
```