#!/bin/sh

###
# Shell function library for Semantic Versioning.
###

set -e
set -o pipefail

##
# Increment the major version component of a Semantic Version string.
# shellcheck disable=SC2039
++major() {
    semver printf '%major %minor %patch' "$1" | awk '{ print ++$1 "." 0 "." 0 }'
}

##
# Increment the minor version component of a Semantic Version string.
# shellcheck disable=SC2039
++minor() {
    semver printf '%major %minor %patch' "$1" | awk '{ print $1 "." ++$2 "." 0 }'
}

##
# Increment the patch version component of a Semantic Version string.
# shellcheck disable=SC2039
++patch() {
    semver printf '%major %minor %patch' "$1" | awk '{ print $1 "." $2 "." ++$3 }'
}