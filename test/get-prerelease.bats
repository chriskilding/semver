#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'get-prerelease: 0.0.0-a should be a' {
    [[ $(semver get-prerelease '0.0.0-a') = 'a' ]]
}

@test "get-prerelease: '' should fail" {
    run semver get-prerelease ''
    [[ "$status" -eq 1 ]]
}

@test 'get-prerelease: should not tolerate whitespace' {
    run semver get-prerelease ' 0.0.0 '
    [[ "$status" -eq 1 ]]
}