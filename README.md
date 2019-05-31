# semver

[![Build Status](https://travis-ci.com/chriskilding/semver.svg?branch=master)](https://travis-ci.com/chriskilding/semver)
[![Codecov](https://codecov.io/gh/chriskilding/semver/branch/master/graph/badge.svg)](https://codecov.io/gh/chriskilding/semver)

Semantic Versioning utility.

## Overview

The `semver` command line utility finds, generates, modifies, parses, sorts, and validates [Semantic Version](https://semver.org/) strings.

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

```bash
semver find <path> [expression]
semver grep [-coq] -
semver printf <format> <version>
semver sort [-r] -
semver [-h]
```

Manual:

```bash
man semver
```

## Examples

See the latest Git tag:

```bash
git tag | semver grep -o | semver sort -r | head -n 1
```    

Validate a candidate version string:

```bash
[[ $(semver grep -q <<< '1.2.3-alpha+1') ]] && echo 'Valid'
```

Format a list of version tags as CSV:

```bash
git tag | semver grep -o | xargs semver printf '%major,%minor,%patch,%prerelease,%build' {}
```

Download all artifacts in a version range:

```bash
version='0.0.1'
while curl -fs "https://example.com/artifact/$version.tar.gz" > "$version.tar.gz"; do
    version=$(semver printf '%major %minor %patch' "$version" | awk '{ print $1 "." $2 "." ++$3 }')
done
```

Increment the current Git tag:

```bash
current=$(git tag | semver grep -o | semver sort -r | head -n 1)
next=$(semver printf '%major %minor %patch' "$current" | awk '{ print ++$1 "." 0 "." 0 }')
```

Find filenames containing Semantic Versions inside a directory:

```bash
semver find . -type f
```

## Extras

The following wrapper functions can make common versioning operations easier.

```bash
#!/bin/sh

++major() {
    semver printf '%major %minor %patch' "$1" | awk '{ print ++$1 "." 0 "." 0 }'
}

++minor() {
    semver printf '%major %minor %patch' "$1" | awk '{ print $1 "." ++$2 "." 0 }'
}

++patch() {
    semver printf '%major %minor %patch' "$1" | awk '{ print $1 "." $2 "." ++$3 }'
}
```

The above example of incrementing a Git tag then becomes:

```bash
++major $(git tag | semver grep -o | semver sort -r | head -n 1)
```
