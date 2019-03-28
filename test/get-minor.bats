#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'get-minor: 0.1.0 should be 1' {
    [[ $(semver get-minor "0.1.0") = "1" ]]
}

@test "get-minor: '' should fail" {
    run semver get-minor ""
    [[ "$status" -eq 1 ]]
}

@test 'get-minor: should not tolerate whitespace' {
    run semver get-minor " 0.0.0 "
    [[ "$status" -eq 1 ]]
}