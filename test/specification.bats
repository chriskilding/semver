#!/usr/bin/env bats

##
## The semver.org specification.
##

semver() {
    ./semver "$@"
}

++major() {
    semver -t <<< "$@" | awk -F '\\t' '{ print ++$1 "." 0 "." 0 }'
}

++minor() {
    semver -t <<< "$@" | awk -F '\\t' '{ print $1 "." ++$2 "." 0 }'
}

++patch() {
    semver -t <<< "$@" | awk -F '\\t' '{ print $1 "." $2 "." ++$3 }'
}

seq() {
    printf "$1\n$2\n"
}

##
## Normal versions <https://semver.org/spec/v2.0.0.html#spec-item-2>
##

@test "A normal version number MUST take the form X.Y.Z..." {
    run semver -q <<< "1.0.0"
    [[ "$status" -eq 0 ]]
}

@test "...where X, Y, and Z are non-negative integers..." {
    run semver -q <<< "-1.-1.-1"
    [[ "$status" -eq 1 ]]
}

@test "...and MUST NOT contain leading zeroes." {
    run semver -q <<< "01.01.01"
    [[ "$status" -eq 1 ]]
}

@test "X is the major version, Y is the minor version, and Z is the patch version." {
    [[ $(semver -t <<< "1.9.0") = $(printf '1\t9\t0') ]]
}

@test "Each element MUST increase numerically. For instance: 1.9.0 -> 1.10.0 -> 1.11.0." {
    [[ $(++minor "1.9.0") = "1.10.0" ]] && [[ $(++minor "1.10.0") = "1.11.0" ]]
}

##
## Major version zero <https://semver.org/spec/v2.0.0.html#spec-item-4>
##

@test "Major version zero (0.y.z) is for initial development." {
    run semver -q <<< "0.0.0"
    [[ "$status" -eq 0 ]]
}

##
## Version one <https://semver.org/spec/v2.0.0.html#spec-item-5>
##

@test "Version 1.0.0 defines the public API." {
    run semver -q <<< "1.0.0"
    [[ "$status" -eq 0 ]]
}

##
## Patch version <https://semver.org/spec/v2.0.0.html#spec-item-6>
##

@test "Patch version Z (x.y.Z | x > 0) MUST be incremented if only backwards compatible bug fixes are introduced." {
    [[ $(++patch "1.0.0") = "1.0.1" ]]
}

##
## Minor version <https://semver.org/spec/v2.0.0.html#spec-item-7>
##

@test "Minor version Y (x.Y.z | x > 0) MUST be incremented if new, backwards compatible functionality is introduced to the public API." {
    [[ $(++minor "1.0.0") = "1.1.0" ]]
}

@test "Patch version MUST be reset to 0 when minor version is incremented." {
    [[ $(++minor "0.0.1") = "0.1.0" ]]
}

##
## Major version <https://semver.org/spec/v2.0.0.html#spec-item-8>
##

@test "Major version X (X.y.z | X > 0) MUST be incremented if any backwards incompatible changes are introduced to the public API." {
    [[ $(++major "1.0.0") = "2.0.0" ]]
}

@test "Patch and minor version MUST be reset to 0 when major version is incremented." {
    [[ $(++major "0.1.2") = "1.0.0" ]]
}

##
## Pre-release <https://semver.org/spec/v2.0.0.html#spec-item-9>
##

@test "A pre-release version MAY be denoted by appending a hyphen and a series of dot separated identifiers immediately following the patch version." {
    [[ $(semver -t <<< "0.0.0-a.b.c" | cut -f 4) = "a.b.c" ]]
}

@test "Pre-release identifiers MUST comprise only ASCII alphanumerics and hyphen [0-9A-Za-z-]." {
    [[ $(semver -t <<< "0.0.0-09AZaz-" | cut -f 4) = "09AZaz-" ]]
}

@test "Pre-release identifiers MUST NOT be empty." {
    run semver -q <<< "0.0.0-a..c"
    [[ "$status" -eq 1 ]]
}

@test "Pre-release numeric identifiers MUST NOT include leading zeroes." {
    run semver -q <<< "0.0.0-1.02.3"
    [[ "$status" -eq 1 ]]
}

@test "Pre-release versions have a lower precedence than the associated normal version." {
    expected=$(cat <<EOF
0.0.1-alpha
0.0.1
EOF
)

    actual=$(semver -s <<EOF
0.0.1
0.0.1-alpha
EOF
)

    [[ ${actual} = ${expected} ]]
}

@test "Example: 1.0.0-alpha" {
    [[ $(semver -t <<< '1.0.0-alpha' | cut -f 4) = 'alpha' ]]
}

@test "Example: 1.0.0-alpha.1" {
    [[ $(semver -t <<< '1.0.0-alpha.1' | cut -f 4) = 'alpha.1' ]]
}

@test "Example: 1.0.0-0.3.7" {
    [[ $(semver -t <<< '1.0.0-0.3.7' | cut -f 4) = '0.3.7' ]]
}

@test "Example: 1.0.0-x.7.z.92" {
    [[ $(semver -t <<< '1.0.0-x.7.z.92' | cut -f 4) = 'x.7.z.92' ]]
}

##
## Build metadata <https://semver.org/spec/v2.0.0.html#spec-item-10>
##

@test "Build metadata MAY be denoted by appending a plus sign and a series of dot separated identifiers immediately following the patch or pre-release version." {
    [[ $(semver -t <<< "0.0.0+a.b.c" | cut -f 5) = "a.b.c" ]]
}

@test "Build identifiers MUST comprise only ASCII alphanumerics and hyphen [0-9A-Za-z-]." {
    [[ $(semver -t <<< "0.0.0+09AZaz-" | cut -f 5) = "09AZaz-" ]]
}

@test "Build identifiers MUST NOT be empty." {
    run semver -q <<< "0.0.0+a..c"
    [[ "$status" -eq 1 ]]
}

@test "Build metadata SHOULD be ignored when determining version precedence. Thus two versions that differ only in the build metadata, have the same precedence." {
    expected=$(cat <<EOF
0.0.1+2008
0.0.1+2009
EOF
)

    actual=$(semver -s <<EOF
0.0.1+2009
0.0.1+2008
EOF
)

    [[ ${actual} = ${expected} ]]
}

@test "Example: 1.0.0-alpha+001" {
    [[ $(semver -t <<< '1.0.0-alpha+001' | cut -f 5) = "001" ]]
}

@test "Example: 1.0.0+20130313144700" {
    [[ $(semver -t <<< "1.0.0+20130313144700" | cut -f 5) = "20130313144700" ]]
}

@test "Example: 1.0.0-beta+exp.sha.5114f85" {
    [[ $(semver -t <<< "1.0.0-beta+exp.sha.5114f85" | cut -f 5) = "exp.sha.5114f85" ]]
}

##
## Precedence <https://semver.org/spec/v2.0.0.html#spec-item-11>
##

@test 'Major, minor, and patch versions are always compared numerically [not lexicographically].' {
    expected=$(cat <<EOF
200.0.0
19999.0.0
EOF
)

    actual=$(semver -s <<EOF
19999.0.0
200.0.0
EOF
)

    [[ ${actual} = ${expected} ]]
}

@test 'Example: 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1' {
    expected=$(cat <<EOF
1.0.0
2.0.0
2.1.0
2.1.1
EOF
)

    actual=$(semver -s <<EOF
2.1.0
1.0.0
2.1.1
2.0.0
EOF
)

    [[ ${actual} = ${expected} ]]
}

#
# Precedence for two pre-release versions with the same major, minor, and patch version MUST be determined by comparing
# each dot separated identifier from left to right until a difference is found as follows...
#

@test 'Identifiers consisting of only digits are compared numerically.' {
    expected=$(cat <<EOF
1.0.0-1
1.0.0-2
EOF
)

    actual=$(semver -s <<EOF
1.0.0-2
1.0.0-1
EOF
)

    [[ ${actual} = ${expected} ]]
}

@test 'Identifiers with letters or hyphens are compared lexically in ASCII -s order.' {
    expected=$(cat <<EOF
1.0.0-a-a
1.0.0-a-b
EOF
)

    actual=$(semver -s <<EOF
1.0.0-a-b
1.0.0-a-a
EOF
)

    [[ ${actual} = ${expected} ]]
}

@test 'Numeric identifiers always have lower precedence than non-numeric identifiers.' {
    expected=$(cat <<EOF
1.0.0-1
1.0.0-a
EOF
)

    actual=$(semver -s <<EOF
1.0.0-a
1.0.0-1
EOF
)

    [[ ${actual} = ${expected} ]]
}

@test 'A larger set of pre-release fields has a higher precedence than a smaller set, if all of the preceding identifiers are equal.' {
    expected=$(cat <<EOF
1.0.0-1.1
1.0.0-1.1.1
EOF
)

    actual=$(semver -s <<EOF
1.0.0-1.1.1
1.0.0-1.1
EOF
)

    [[ ${actual} = ${expected} ]]
}

@test 'Example: 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0' {
    expected=$(cat <<EOF
1.0.0-alpha
1.0.0-alpha.1
1.0.0-alpha.beta
1.0.0-beta
1.0.0-beta.2
1.0.0-beta.11
1.0.0-rc.1
1.0.0
EOF
)

    actual=$(semver -s <<EOF
1.0.0-beta.11
1.0.0-alpha.1
1.0.0-beta.2
1.0.0
1.0.0-alpha
1.0.0-rc.1
1.0.0-alpha.beta
1.0.0-beta
EOF
)

    [[ ${actual} = ${expected} ]]
}

@test 'When major, minor, and patch are equal, a pre-release version has lower precedence than a normal version. Example: 1.0.0-alpha < 1.0.0.' {
    expected=$(cat <<EOF
1.0.0-alpha
1.0.0
EOF
)

    actual=$(semver -s <<EOF
1.0.0
1.0.0-alpha
EOF
)

    [[ ${actual} = ${expected} ]]
}
