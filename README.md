# semver

[![Build Status](https://travis-ci.com/chriskilding/semver.svg?branch=master)](https://travis-ci.com/chriskilding/semver)
[![Codecov](https://codecov.io/gh/chriskilding/semver/branch/master/graph/badge.svg)](https://codecov.io/gh/chriskilding/semver)

Semantic Versioning utility.

## Overview

The `semver` command line utility extracts, increments, parses, sorts, and validates [Semantic Version](https://semver.org/) strings.

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

## Help

Usage:

```bash
semver [-hqst]
```

Options:

- `-h --help`  
  Show the help screen.
- `-q --quiet`  
  Quiet mode (suppress normal output).
- `-s --sort`  
  Sort the matched versions in precedence order (low-to-high).
- `-t --tabulate`  
  Tabulate the matched versions (separator: '\t').

Manual:

```bash
man semver
```

## Examples

Cut out the major, minor, and patch components of a version:

```bash
semver -t <<< '1.2.3-alpha+1' | cut -f 1-3
```

Find Semantic Versions in filenames in a directory:

```bash
find . -type f -execdir echo '{}' ';' | semver
```

Format versions as CSV:

```bash
git tag | semver -t | tr '\t' ','
```

Get the latest Git tag:

```bash
git tag | semver -s | tail -n 1
```

Validate a candidate version string:

```bash
semver -q <<< '1.2.3' && echo 'Valid'
```

## Extras

The following wrapper functions can make complex versioning operations easier:

```bash
#!/bin/sh

++major() {
    semver -t <<< "$1" | awk -F '\t' '{ print ++$1 "." 0 "." 0 }'
}

++minor() {
    semver -t <<< "$1" | awk -F '\t' '{ print $1 "." ++$2 "." 0 }'
}

++patch() {
    semver -t <<< "$1" | awk -F '\t' '{ print $1 "." $2 "." ++$3 }'
}
```

Download all artifacts in a version range:

```bash
v='0.0.1'
while curl -fs "https://example.com/artifact/$v.tar.gz" > "$v.tar.gz"; do
    v=$(++patch "$v")
done
```

Increment the current Git tag:

```bash
++patch $(git tag | semver -s | tail -n 1)
```