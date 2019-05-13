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

@test 'semver: 0.0.0 should be [0,0,0,_,_]' {
    [[ $(semver '0.0.0') = $(triple '0' '0' '0') ]]
}

@test 'semver: 0.1.0 should be [0,1,0,_,_]' {
    [[ $(semver '0.1.0') = $(triple '0' '1' '0') ]]
}

@test 'semver: 0.0.1 should be [0,0,1,_,_]' {
    [[ $(semver '0.0.1') = $(triple '0' '0' '1') ]]
}

@test 'semver: 1.0.0 should be [1,0,0,_,_]' {
    [[ $(semver '1.0.0') = $(triple '1' '0' '0') ]]
}

@test 'semver: 10.0.0 should be [10,0,0,_,_]' {
    [[ $(semver '10.0.0') = $(triple '10' '0' '0') ]]
}

@test 'semver: 0.10.0 should be [0,10,0,_,_]' {
    [[ $(semver '0.10.0') = $(triple '0' '10' '0') ]]
}

@test 'semver: 0.0.10 should be [0,0,10,_,_]' {
    [[ $(semver '0.0.10') = $(triple '0' '0' '10') ]]
}

@test 'semver: 1.0.0-1 should be [1,0,0,1,_]' {
    [[ $(semver '1.0.0-1') = $(quad '1' '0' '0' '1') ]]
}

@test 'semver: 1.0.0-a should be [1,0,0,a,_]' {
    [[ $(semver '1.0.0-a') = $(quad '1' '0' '0' 'a') ]]
}

@test 'semver: 1.0.0-a-1 should be [1,0,0,a-1,_]' {
    [[ $(semver '1.0.0-a-1') = $(quad '1' '0' '0' 'a-1') ]]
}

@test 'semver: 1.0.0-1.2.3 should be [1,0,0,1.2.3,_]' {
    [[ $(semver '1.0.0-1.2.3') = $(quad '1' '0' '0' '1.2.3') ]]
}

@test 'semver: 1.0.0+1 should be [1,0,0,_,1]' {
    [[ $(semver '1.0.0+1') = $(quintuple '1' '0' '0' '' '1') ]]
}

@test 'semver: 1.0.0+a should be [1,0,0,_,a]' {
    [[ $(semver '1.0.0+a') = $(quintuple '1' '0' '0' '' 'a') ]]
}

@test 'semver: 1.0.0+1.2.3 should be [1,0,0,_,1.2.3]' {
    [[ $(semver '1.0.0+1.2.3') = $(quintuple '1' '0' '0' '' '1.2.3') ]]
}

@test 'semver: 1.0.0-a+1 should be [1,0,0,a,1]' {
    [[ $(semver '1.0.0-a+1') = $(quintuple '1' '0' '0' 'a' '1') ]]
}

# Option flags

@test "semver: --major 1.0.0 should be 1" {
    [[ $(semver --major '1.0.0') = '1' ]]
}

@test 'semver: --minor 0.1.0 should be 1' {
    [[ $(semver --minor '0.1.0') = '1' ]]
}

@test 'semver: --patch 0.0.1 should be 1' {
    [[ $(semver --patch '0.0.1') = '1' ]]
}

@test 'semver: --prerelease 0.0.0-a should be a' {
    [[ $(semver --prerelease '0.0.0-a') = 'a' ]]
}

@test 'semver: --build 0.0.0+a should be a' {
    [[ $(semver --build '0.0.0+a') = 'a' ]]
}

@test 'semver: should allow flag permutation' {
    [[ $(semver '1.0.0' --major) = '1' ]]
}

@test 'semver: should fail with multiple flags' {
    run semver --major --minor '1.0.0'
    [[ "$status" -eq 1 ]]
}

# Negative numbers

@test 'semver: -1.0.0 should fail' {
    run semver '-1.0.0'
    [[ "$status" -eq 1 ]]
}

@test "semver: 0.-1.0 should fail" {
    run semver '0.-1.0'
    [[ "$status" -eq 1 ]]
}

@test "semver: 0.0.-1 should fail" {
    run semver '0.0.-1'
    [[ "$status" -eq 1 ]]
}

# Numeric identifiers with preceding zeroes

@test 'semver: 01.0.0 should fail' {
    run semver '01.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'semver: 0.01.0 should fail' {
    run semver '0.01.0'
    [[ "$status" -eq 1 ]]
}

@test 'semver: 0.0.01 should fail' {
    run semver '0.0.01'
    [[ "$status" -eq 1 ]]
}

# Non-numeric characters in numeric identifiers

@test 'semver: a.0.0 should fail' {
    run semver 'a.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'semver: 0.a.0 should fail' {
    run semver '0.a.0'
    [[ "$status" -eq 1 ]]
}

@test 'semver: 0.0.a should fail' {
    run semver '0.0.a'
    [[ "$status" -eq 1 ]]
}

# Missing identifiers

@test 'semver: .0.0 should fail' {
    run semver '.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'semver: 0..0 should fail' {
    run semver '0..0'
    [[ "$status" -eq 1 ]]
}

@test 'semver: 0.0. should fail' {
    run semver '0.0.'
    [[ "$status" -eq 1 ]]
}

@test "semver: 0.0.0- should fail" {
    run semver '0.0.0-'
    [[ "$status" -eq 1 ]]
}

@test "semver: 0.0.0+ should fail" {
    run semver '0.0.0+'
    [[ "$status" -eq 1 ]]
}

# Whitespace

@test 'semver: should fail with an invalid flag' {
    run semver --foobar '1.0.0'
    [[ "$status" -eq 1 ]]
}

@test "semver: '' should fail" {
    run semver ''
    [[ "$status" -eq 1 ]]
}

@test 'semver: should not tolerate whitespace' {
    run semver ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}

@test "semver: -h should print usage" {
    run semver -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}
