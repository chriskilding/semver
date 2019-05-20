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
    [[ $(semver cut --prerelease <<< '1.0.0') = '' ]]
}

@test "cut: --build should tolerate a missing build" {
    [[ $(semver cut --build <<< '1.0.0') = '' ]]
}

@test 'cut: should allow flag permutation' {
    [[ $(semver cut <<< '1.0.0' --major) = '1' ]]
}

@test 'cut: should fail with multiple flags' {
    run semver cut --major --minor <<< '1.0.0'
    [[ "$status" -eq 1 ]]
}

# Negative numbers

@test 'cut: -1.0.0 should fail' {
    run semver cut --major <<< '-1.0.0'
    [[ "$status" -eq 1 ]]
}

@test "cut: 0.-1.0 should fail" {
    run semver cut --major <<< '0.-1.0'
    [[ "$status" -eq 1 ]]
}

@test "cut: 0.0.-1 should fail" {
    run semver cut --major <<< '0.0.-1'
    [[ "$status" -eq 1 ]]
}

# Numeric identifiers with preceding zeroes

@test 'cut: 01.0.0 should fail' {
    run semver cut --major <<< '01.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'cut: 0.01.0 should fail' {
    run semver cut --major <<< '0.01.0'
    [[ "$status" -eq 1 ]]
}

@test 'cut: 0.0.01 should fail' {
    run semver cut --major <<< '0.0.01'
    [[ "$status" -eq 1 ]]
}

# Non-numeric characters in numeric identifiers

@test 'cut: a.0.0 should fail' {
    run semver cut --major <<< 'a.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'cut: 0.a.0 should fail' {
    run semver cut --major <<< '0.a.0'
    [[ "$status" -eq 1 ]]
}

@test 'cut: 0.0.a should fail' {
    run semver cut --major <<< '0.0.a'
    [[ "$status" -eq 1 ]]
}

# Missing identifiers

@test 'cut: .0.0 should fail' {
    run semver cut --major <<< '.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'cut: 0..0 should fail' {
    run semver cut --major <<< '0..0'
    [[ "$status" -eq 1 ]]
}

@test 'cut: 0.0. should fail' {
    run semver cut --major <<< '0.0.'
    [[ "$status" -eq 1 ]]
}

@test "cut: 0.0.0- should fail" {
    run semver cut --major <<< '0.0.0-'
    [[ "$status" -eq 1 ]]
}

@test "cut: 0.0.0+ should fail" {
    run semver cut --major <<< '0.0.0+'
    [[ "$status" -eq 1 ]]
}

# Whitespace

@test 'cut: should fail with an invalid flag' {
    run semver cut --foobar '1.0.0'
    [[ "$status" -eq 1 ]]
}

@test "cut: '' should fail" {
    run semver cut --major <<< ''
    [[ "$status" -eq 1 ]]
}

@test 'cut: should not tolerate whitespace' {
    run semver cut --major <<< ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}