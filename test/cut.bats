#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

semver_cut_all() {
    input=$1

    major="$(semver cut --major <<< ${input})"
    minor="$(semver cut --minor <<< ${input})"
    patch="$(semver cut --patch <<< ${input})"
    prerelease="$(semver cut --prerelease <<< ${input})"
    build="$(semver cut --build <<< ${input})"

    printf "$major\t$minor\t$patch\t$prerelease\t$build"
}

tuple() {
    printf "$1\t$2\t$3\t$4\t$5"
}

@test 'cut: 0.0.0 should be [0,0,0,_,_]' {
    [[ "$(semver_cut_all '0.0.0')" = "$(tuple '0' '0' '0' '' '')" ]]
}

@test 'cut: 1.0.0 should be [1,0,0,_,_]' {
    [[ "$(semver_cut_all '1.0.0')" = "$(tuple '1' '0' '0' '' '')" ]]
}

@test 'cut: 0.1.0 should be [0,1,0,_,_]' {
    [[ "$(semver_cut_all '0.1.0')" = "$(tuple '0' '1' '0' '' '')" ]]
}

@test 'cut: 0.0.1 should be [0,0,1,_,_]' {
    [[ "$(semver_cut_all '0.0.1')" = "$(tuple '0' '0' '1' '' '')" ]]
}

@test 'cut: 10.0.0 should be [10,0,0,_,_]' {
    [[ "$(semver_cut_all '10.0.0')" = "$(tuple '10' '0' '0' '' '')" ]]
}

@test 'cut: 0.10.0 should be [0,10,0,_,_]' {
    [[ "$(semver_cut_all '0.10.0')" = "$(tuple '0' '10' '0' '' '')" ]]
}

@test 'cut: 0.0.10 should be [0,0,10,_,_]' {
    [[ "$(semver_cut_all '0.0.10')" = "$(tuple '0' '0' '10' '' '')" ]]
}

@test 'cut: 1.0.0-1 should be [1,0,0,1,_]' {
    [[ "$(semver_cut_all '1.0.0-1')" = "$(tuple '1' '0' '0' '1' '')" ]]
}

@test 'cut: 1.0.0-a should be [1,0,0,a,_]' {
    [[ "$(semver_cut_all '1.0.0-a')" = "$(tuple '1' '0' '0' 'a' '')" ]]
}

@test 'cut: 1.0.0-a-1 should be [1,0,0,a-1,_]' {
    [[ "$(semver_cut_all '1.0.0-a-1')" = "$(tuple '1' '0' '0' 'a-1' '')" ]]
}

@test 'cut: 1.0.0-1.2.3 should be [1,0,0,1.2.3,_]' {
    [[ "$(semver_cut_all '1.0.0-1.2.3')" = "$(tuple '1' '0' '0' '1.2.3' '')" ]]
}

@test 'cut: 1.0.0+1 should be [1,0,0,_,1]' {
    [[ "$(semver_cut_all '1.0.0+1')" = "$(tuple '1' '0' '0' '' '1')" ]]
}

@test 'cut: 1.0.0+a should be [1,0,0,_,a]' {
     [[ "$(semver_cut_all '1.0.0+a')" = "$(tuple '1' '0' '0' '' 'a')" ]]
}

@test 'cut: 1.0.0+1.2.3 should be [1,0,0,_,1.2.3]' {
     [[ "$(semver_cut_all '1.0.0+1.2.3')" = "$(tuple '1' '0' '0' '' '1.2.3')" ]]
}

@test 'cut: 1.0.0-a+1 should be [1,0,0,a,1]' {
     [[ "$(semver_cut_all '1.0.0-a+1')" = "$(tuple '1' '0' '0' 'a' '1')" ]]
}

@test "cut: should handle multiple lines" {
    input=$(cat <<EOF
1.0.0-alpha+1
2.0.0-alpha+1
3.0.0-alpha+1
EOF
)

    expected=$(cat <<EOF
1
2
3
EOF
)

    [[ $(semver cut --major <<< "$input") = "$(printf "$expected")" ]]
}

@test "cut: should handle multiple lines and pass through erroneous lines unmodified" {
    input=$(cat <<EOF
1.0.0-alpha+1
rubbish
3.0.0-alpha+1
EOF
)

    expected=$(cat <<EOF
1
rubbish
3
EOF
)

    [[ $(semver cut --major <<< "$input") = "$(printf "$expected")" ]]
}

@test "cut -s: should handle multiple lines and suppress erroneous lines" {
    input=$(cat <<EOF
1.0.0-alpha+1
rubbish
3.0.0-alpha+1
EOF
)

    expected=$(cat <<EOF
1
3
EOF
)

    [[ $(semver cut -s --major <<< "$input") = "$(printf "$expected")" ]]
}

# Flags

@test "cut: --major 1.0.0 should be 1" {
    [[ $(semver cut --major <<< '1.0.0') = '1' ]]
}

@test 'cut: --minor 0.1.0 should be 1' {
    [[ $(semver cut --minor <<< '0.1.0') = '1' ]]
}

@test 'cut: --patch 0.0.1 should be 1' {
    [[ $(semver cut --patch <<< '0.0.1') = '1' ]]
}

@test 'cut: --prerelease 0.0.0-a should be a' {
    [[ $(semver cut --prerelease <<< '0.0.0-a') = 'a' ]]
}

@test 'cut: --build 0.0.0+a should be a' {
    [[ $(semver cut --build <<< '0.0.0+a') = 'a' ]]
}

@test "cut: --prerelease should tolerate a missing prerelease" {
    [[ -z $(semver cut --prerelease <<< '1.0.0') ]]
}

@test "cut: --build should tolerate a missing build" {
    [[ -z $(semver cut --build <<< '1.0.0') ]]
}

@test 'cut: should allow flag permutation' {
    [[ $(semver cut <<< '1.0.0' --major) = '1' ]]
}

@test 'cut: should fail with multiple flags' {
    run semver cut --major --minor <<< '1.0.0'
    [[ "$status" -eq 1 ]]
}

# Negative numbers

@test 'cut -s: -1.0.0 should be suppressed' {
    [[ -z $(semver cut -s --major <<< '-1.0.0') ]]
}

@test "cut -s: 0.-1.0 should be suppressed" {
    [[ -z $(semver cut -s --minor <<< '0.-1.0') ]]
}

@test "cut -s: 0.0.-1 should be suppressed" {
    [[ -z $(semver cut -s --patch <<< '0.0.-1') ]]
}

# Numeric identifiers with preceding zeroes

@test 'cut -s: 01.0.0 should be suppressed' {
    [[ -z $(semver cut -s --major <<< '01.0.0') ]]
}

@test 'cut -s: 0.01.0 should be suppressed' {
    [[ -z $(semver cut -s --minor <<< '0.01.0') ]]
}

@test 'cut -s: 0.0.01 should be suppressed' {
    [[ -z $(semver cut -s --patch <<< '0.0.01') ]]
}

# Non-numeric characters in numeric identifiers

@test 'cut -s: a.0.0 should be suppressed' {
    [[ -z $(semver cut -s --major <<< 'a.0.0') ]]
}

@test 'cut -s: 0.a.0 should be suppressed' {
    [[ -z $(semver cut -s --minor <<< '0.a.0') ]]
}

@test 'cut -s: 0.0.a should be suppressed' {
    [[ -z $(semver cut -s --patch <<< '0.0.a') ]]
}

# Missing identifiers

@test 'cut: .0.0 should be suppressed' {
    [[ -z $(semver cut -s --major <<< '.0.0') ]]
}

@test 'cut: 0..0 should be suppressed' {
    [[ -z $(semver cut -s --minor <<< '0..0') ]]
}

@test 'cut -s: 0.0. should be suppressed' {
    [[ -z $(semver cut -s --patch <<< '0.0.') ]]
}

@test "cut -s: 0.0.0- should be suppressed" {
    [[ -z $(semver cut -s --major <<< '0.0.0-') ]]
}

@test "cut -s: 0.0.0+ should be suppressed" {
    [[ -z $(semver cut -s --major <<< '0.0.0+') ]]
}

# Whitespace

@test 'cut: should fail with an invalid flag' {
    run semver cut --foobar '1.0.0'
    [[ "$status" -eq 1 ]]
}

# FIXME this should fail, there should not be a newline in the output if the input is a zero-length string
@test "cut: '' should be ''" {
    [[ -z "$(semver cut --major <<< '')" ]]
    [[ 0 -eq 1 ]]
}

# FIXME regular 'cut' can tolerate whitespace - maybe we should too?
@test 'cut: should not tolerate whitespace' {
    run semver cut --major <<< ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}