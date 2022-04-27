# semver

[![Codecov](https://codecov.io/gh/chriskilding/semver/branch/master/graph/badge.svg)](https://codecov.io/gh/chriskilding/semver)

Semantic Versioning utility.

## Description

The `semver` utility is a text filter for [Semantic Version](https://semver.org/) strings. It searches text from the standard input, selects any Semantic Versions that are present, and writes them to the standard output. It can optionally sort or tabulate the selected versions.

A *version* string will be selected within the text stream if the following criteria are met:

- *version* is a valid Semantic Version.
- *version* is a whole line. (This can be modified with the `-w` option.)

## Install

### Homebrew

```bash
brew tap chriskilding/semver
brew install semver
```

### From source

Dependencies:

- [Perl](http://www.perl.org) 5+ (pre-installed on: macOS, Debian, openSUSE)
- [Bats](https://github.com/bats-core/bats-core) (test)

```bash
make
make test # optional
make install
```

## Usage

```bash
semver [-hiqstw]
```

Options:

- `-h --help`
  Show the help screen.
- `-i --increment <major|minor|patch>`
  Increment the specified component of the matched versions.
- `-q --quiet`
  Quiet - suppress normal output.
- `-s --sort`
  Sort the matched versions in precedence order (low-to-high).
- `-t --tabulate`
  Tabulate the matched versions (separator: '\t').
- `-w --word-match`
  Select words that match the semver pattern. (Equivalent to the *grep(1)* `--word-regexp` option.)

Options can be combined. For example, `semver -stw` will word-match occurrences of semvers, sort them, and print them in tabulated form. 

## Manual

```bash
man semver
```

## Examples

**Select** lines that are version strings:

```bash
semver < example.txt
```

**Calculate** the next Git tag:

```bash
git tag | semver -s | tail -n 1 | semver -i major

git tag | semver -s | tail -n 1 | semver -i minor

git tag | semver -s | tail -n 1 | semver -i patch
```

**Cut** out the major, minor, and patch components of a version:

```bash
semver -t <<< '1.2.3-alpha+1' | cut -f 1-3
```

**Download** all artifacts in a version range:

```bash
v='0.0.1'
while curl -fs "https://example.com/artifact/$v.tar.gz" > "$v.tar.gz"; do
    v=$(semver -i patch <<< "$v")
done
```

**Find** the current Git tag:

```bash
git tag | semver -s | tail -n 1
```

**Format** versions as CSV:

```bash
semver -tw < example.txt | tr '\t' ','
```

**Validate** a candidate version string:

```bash
semver -q <<< '1.2.3' && echo 'ok'
```
