#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

join() {
    printf "$1\t$2\t$3\t$4\t$5"
}

@test 'get: 0.0.0 should be [0,0,0,_,_]' {
    [[ $(semver get '0.0.0') = $(join '0' '0' '0') ]]
}

@test 'get: 0.1.0 should be [0,1,0,_,_]' {
    [[ $(semver get '0.1.0') = $(join '0' '1' '0') ]]
}

@test 'get: 0.0.1 should be [0,0,1,_,_]' {
    [[ $(semver get '0.0.1') = $(join '0' '0' '1') ]]
}

@test 'get: 1.0.0 should be [1,0,0,_,_]' {
    [[ $(semver get '1.0.0') = $(join '1' '0' '0') ]]
}

@test 'get: 10.0.0 should be [10,0,0,_,_]' {
    [[ $(semver get '10.0.0') = $(join '10' '0' '0') ]]
}

@test 'get: 0.10.0 should be [0,10,0,_,_]' {
    [[ $(semver get '0.10.0') = $(join '0' '10' '0') ]]
}

@test 'get: 0.0.10 should be [0,0,10,_,_]' {
    [[ $(semver get '0.0.10') = $(join '0' '0' '10') ]]
}

@test 'get: 1.0.0-1 should be [1,0,0,1,_]' {
    [[ $(semver get '1.0.0-1') = $(join '1' '0' '0' '1') ]]
}

@test 'get: 1.0.0-a should be [1,0,0,a,_]' {
    [[ $(semver get '1.0.0-a') = $(join '1' '0' '0' 'a') ]]
}

@test 'get: 1.0.0-a-1 should be [1,0,0,a-1,_]' {
    [[ $(semver get '1.0.0-a-1') = $(join '1' '0' '0' 'a-1') ]]
}

@test 'get: 1.0.0-1.2.3 should be [1,0,0,1.2.3,_]' {
    [[ $(semver get '1.0.0-1.2.3') = $(join '1' '0' '0' '1.2.3') ]]
}

@test 'get: 1.0.0+1 should be [1,0,0,_,1]' {
    [[ $(semver get '1.0.0+1') = $(join '1' '0' '0' '' '1') ]]
}

@test 'get: 1.0.0+a should be [1,0,0,_,a]' {
    [[ $(semver get '1.0.0+a') = $(join '1' '0' '0' '' 'a') ]]
}

@test 'get: 1.0.0+1.2.3 should be [1,0,0,_,1.2.3]' {
    [[ $(semver get '1.0.0+1.2.3') = $(join '1' '0' '0' '' '1.2.3') ]]
}

@test 'get: 1.0.0-a+1 should be [1,0,0,a,1]' {
    [[ $(semver get '1.0.0-a+1') = $(join '1' '0' '0' 'a' '1') ]]
}

# Option flags

@test "get --major: 1.0.0 should be 1" {
    [[ $(semver get --major '1.0.0') = '1' ]]
}

@test 'get --minor: 0.1.0 should be 1' {
    [[ $(semver get --minor '0.1.0') = '1' ]]
}

@test 'get --patch: 0.0.1 should be 1' {
    [[ $(semver get --patch '0.0.1') = '1' ]]
}

@test 'get --prerelease: 0.0.0-a should be a' {
    [[ $(semver get --prerelease '0.0.0-a') = 'a' ]]
}

@test 'get --build: 0.0.0+a should be a' {
    [[ $(semver get --build '0.0.0+a') = 'a' ]]
}

@test 'get: should allow flag permutation' {
    [[ $(semver get '1.0.0' --major) = '1' ]]
}

@test 'get: should fail with multiple flags' {
    run semver get --major --minor '1.0.0'
    [[ "$status" -eq 1 ]]
}

# Negative numbers

@test 'get: -1.0.0 should fail' {
    run semver get '-1.0.0'
    [[ "$status" -eq 1 ]]
}

@test "get: 0.-1.0 should fail" {
    run semver get '0.-1.0'
    [[ "$status" -eq 1 ]]
}

@test "get: 0.0.-1 should fail" {
    run semver get '0.0.-1'
    [[ "$status" -eq 1 ]]
}

# Numeric identifiers with preceding zeroes

@test 'get: 01.0.0 should fail' {
    run semver get '01.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'get: 0.01.0 should fail' {
    run semver get '0.01.0'
    [[ "$status" -eq 1 ]]
}

@test 'get: 0.0.01 should fail' {
    run semver get '0.0.01'
    [[ "$status" -eq 1 ]]
}

# Non-numeric characters in numeric identifiers

@test 'get: a.0.0 should fail' {
    run semver get 'a.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'get: 0.a.0 should fail' {
    run semver get '0.a.0'
    [[ "$status" -eq 1 ]]
}

@test 'get: 0.0.a should fail' {
    run semver get '0.0.a'
    [[ "$status" -eq 1 ]]
}

# Missing identifiers

@test 'get: .0.0 should fail' {
    run semver get '.0.0'
    [[ "$status" -eq 1 ]]
}

@test 'get: 0..0 should fail' {
    run semver get '0..0'
    [[ "$status" -eq 1 ]]
}

@test 'get: 0.0. should fail' {
    run semver get '0.0.'
    [[ "$status" -eq 1 ]]
}

@test "get: 0.0.0- should fail" {
    run semver get '0.0.0-'
    [[ "$status" -eq 1 ]]
}

@test "get: 0.0.0+ should fail" {
    run semver get '0.0.0+'
    [[ "$status" -eq 1 ]]
}

# Whitespace

@test 'get: should fail with an invalid flag' {
    run semver get --foobar '1.0.0'
    [[ "$status" -eq 1 ]]
}

@test "get: '' should fail" {
    run semver get ''
    [[ "$status" -eq 1 ]]
}

@test 'get: should not tolerate whitespace' {
    run semver get ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}