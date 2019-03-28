#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "get-major: 1.0.0 should be 1" {
    [[ $(semver get-major '1.0.0') = '1' ]]
}

@test "get-major: '' should fail" {
    run semver get-major ''
    [[ "$status" -eq 1 ]]
}

@test "get-major: should not tolerate whitespace" {
    run semver get-major ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}