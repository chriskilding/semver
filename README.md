# semver

[![Build Status](https://travis-ci.com/chriskilding/semver.svg?branch=master)](https://travis-ci.com/chriskilding/semver)
[![Codecov](https://codecov.io/gh/chriskilding/semver/branch/master/graph/badge.svg)](https://codecov.io/gh/chriskilding/semver)

Semantic Versioning utility.

## Overview

The `semver` command line utility generates, modifies, parses, sorts, and validates [Semantic Version](https://semver.org/) strings.

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

    semver decrement [-major | -minor | -patch] <version>
    semver grep [-coq] -
    semver increment [-major | -minor | -patch] <version>
    semver printf <format> <version>
    semver sort [-r] -
    semver [-h]

Man page:

```bash
$ man semver
```

## Examples

Find the latest Git tag:

```bash
git tag | semver grep -o | semver sort -r | head -n 1
```    

Validate a candidate version string:

```bash
[[ $(semver grep -q <<< "1.2.3-alpha+1") ]] && echo "Valid"
```

Download all artifacts in a version range:

```bash
version="0.0.1"
while curl -fs "https://example.com/artifact/$version.tar.gz" > "$version.tar.gz"; do
    version=$(semver increment -patch ${version})
done
```

Format a list of version strings as CSV:

```bash
git tag | semver grep -o | xargs semver printf "%major,%minor,%patch,%prerelease,%build" {}
```