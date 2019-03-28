#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'get-build: 0.0.0+a should be a' {
    [[ $(semver get-build '0.0.0+a') = 'a' ]]
}

@test "get-build: '' should fail" {
    run semver get-build ''
    [[ "$status" -eq 1 ]]
}

@test 'get-build: should not tolerate whitespace' {
    run semver get-build ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}