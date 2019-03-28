#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'get-patch: 0.0.1 should be 1' {
    [[ $(semver get-patch '0.0.1') = '1' ]]
}

@test "get-patch: '' should fail" {
    run semver get-patch ''
    [[ "$status" -eq 1 ]]
}

@test 'get-patch: should not tolerate whitespace' {
    run semver get-patch ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}