#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

triple() {
    printf "$1\t$2\t$3"
}

quad() {
    printf "$1\t$2\t$3\t$4"
}

quintuple() {
    printf "$1\t$2\t$3\t$4\t$5"
}

@test 'awk: 0.0.0 should be [0,0,0,_,_]' {
    [[ $(semver awk <<< '0.0.0') = $(triple '0' '0' '0') ]]
}

@test 'awk: 0.1.0 should be [0,1,0,_,_]' {
    [[ $(semver awk <<< '0.1.0') = $(triple '0' '1' '0') ]]
}

@test 'awk: 0.0.1 should be [0,0,1,_,_]' {
    [[ $(semver awk <<< '0.0.1') = $(triple '0' '0' '1') ]]
}

@test 'awk: 1.0.0 should be [1,0,0,_,_]' {
    [[ $(semver awk <<< '1.0.0') = $(triple '1' '0' '0') ]]
}

@test 'awk: 10.0.0 should be [10,0,0,_,_]' {
    [[ $(semver awk <<< '10.0.0') = $(triple '10' '0' '0') ]]
}

@test 'awk: 0.10.0 should be [0,10,0,_,_]' {
    [[ $(semver awk <<< '0.10.0') = $(triple '0' '10' '0') ]]
}

@test 'awk: 0.0.10 should be [0,0,10,_,_]' {
    [[ $(semver awk <<< '0.0.10') = $(triple '0' '0' '10') ]]
}

@test 'awk: 1.0.0-1 should be [1,0,0,1,_]' {
    [[ $(semver awk <<< '1.0.0-1') = $(quad '1' '0' '0' '1') ]]
}

@test 'awk: 1.0.0-a should be [1,0,0,a,_]' {
    [[ $(semver awk <<< '1.0.0-a') = $(quad '1' '0' '0' 'a') ]]
}

@test 'awk: 1.0.0-a-1 should be [1,0,0,a-1,_]' {
    [[ $(semver awk <<< '1.0.0-a-1') = $(quad '1' '0' '0' 'a-1') ]]
}

@test 'awk: 1.0.0-1.2.3 should be [1,0,0,1.2.3,_]' {
    [[ $(semver awk <<< '1.0.0-1.2.3') = $(quad '1' '0' '0' '1.2.3') ]]
}

@test 'awk: 1.0.0+1 should be [1,0,0,_,1]' {
    [[ $(semver awk <<< '1.0.0+1') = $(quintuple '1' '0' '0' '' '1') ]]
}

@test 'awk: 1.0.0+a should be [1,0,0,_,a]' {
    [[ $(semver awk <<< '1.0.0+a') = $(quintuple '1' '0' '0' '' 'a') ]]
}

@test 'awk: 1.0.0+1.2.3 should be [1,0,0,_,1.2.3]' {
    [[ $(semver awk <<< '1.0.0+1.2.3') = $(quintuple '1' '0' '0' '' '1.2.3') ]]
}

@test 'awk: 1.0.0-a+1 should be [1,0,0,a,1]' {
    [[ $(semver awk <<< '1.0.0-a+1') = $(quintuple '1' '0' '0' 'a' '1') ]]
}

@test "awk: should handle multiple lines" {
    input=$(cat <<EOF
1.0.0-alpha+1
2.0.0-alpha+1
3.0.0-alpha+1
EOF
)

    expected=$(cat <<EOF
1\t0\t0\talpha\t1
2\t0\t0\talpha\t1
3\t0\t0\talpha\t1
EOF
)

    [[ $(semver awk <<< "$input") = "$(printf "$expected")" ]]
}

@test "awk --major: should handle multiple lines" {
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

    [[ $(semver awk --major <<< "$input") = "$(printf "$expected")" ]]
}

# Option flags

@test "awk --major: 1.0.0 should be 1" {
    [[ $(semver awk --major <<< '1.0.0') = '1' ]]
}

@test 'awk --minor: 0.1.0 should be 1' {
    [[ $(semver awk --minor <<< '0.1.0') = '1' ]]
}

@test 'awk --patch: 0.0.1 should be 1' {
    [[ $(semver awk --patch <<< '0.0.1') = '1' ]]
}

@test 'awk --prerelease: 0.0.0-a should be a' {
    [[ $(semver awk --prerelease <<< '0.0.0-a') = 'a' ]]
}

@test 'awk --build: 0.0.0+a should be a' {
    [[ $(semver awk --build <<< '0.0.0+a') = 'a' ]]
}

@test "awk --prerelease: should tolerate a missing prerelease" {
    [[ $(semver awk --prerelease <<< '1.0.0') = '' ]]
}

@test "awk --build: should tolerate a missing build" {
    [[ $(semver awk --build <<< '1.0.0') = '' ]]
}

@test 'awk: should allow flag permutation' {
    [[ $(semver awk <<< '1.0.0' --major) = '1' ]]
}

@test 'awk: should fail with multiple flags' {
    run semver awk --major --minor <<< '1.0.0'
    [[ "$status" -eq 1 ]]
}

# Negative numbers

@test 'awk: -1.0.0 should fail' {
    run semver awk <<< '-1.0.0'
    [[ "$status" -eq 1 ]]
}

@test "awk: 0.-1.0 should fail" {
    run semver awk <<< '0.-1.0'
    [[ "$status" -eq 1 ]]
}

@test "awk: 0.0.-1 should fail" {
    run semver awk <<< '0.0.-1'
    [[ "$status" -eq 1 ]]
}

# Numeric identifiers with preceding zeroes

@test 'awk: 01.0.0 should fail' {
    run semver awk <<< '01.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'awk: 0.01.0 should fail' {
    run semver awk <<< '0.01.0'
    [[ "$status" -eq 1 ]]
}

@test 'awk: 0.0.01 should fail' {
    run semver awk <<< '0.0.01'
    [[ "$status" -eq 1 ]]
}

# Non-numeric characters in numeric identifiers

@test 'awk: a.0.0 should fail' {
    run semver awk <<< 'a.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'awk: 0.a.0 should fail' {
    run semver awk <<< '0.a.0'
    [[ "$status" -eq 1 ]]
}

@test 'awk: 0.0.a should fail' {
    run semver awk <<< '0.0.a'
    [[ "$status" -eq 1 ]]
}

# Missing identifiers

@test 'awk: .0.0 should fail' {
    run semver awk <<< '.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'awk: 0..0 should fail' {
    run semver awk <<< '0..0'
    [[ "$status" -eq 1 ]]
}

@test 'awk: 0.0. should fail' {
    run semver awk <<< '0.0.'
    [[ "$status" -eq 1 ]]
}

@test "awk: 0.0.0- should fail" {
    run semver awk <<< '0.0.0-'
    [[ "$status" -eq 1 ]]
}

@test "awk: 0.0.0+ should fail" {
    run semver awk <<< '0.0.0+'
    [[ "$status" -eq 1 ]]
}

# Whitespace

@test 'awk: should fail with an invalid flag' {
    run semver awk --foobar '1.0.0'
    [[ "$status" -eq 1 ]]
}

@test "awk: '' should fail" {
    run semver awk <<< ''
    [[ "$status" -eq 1 ]]
}

@test 'awk: should not tolerate whitespace' {
    run semver awk <<< ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}