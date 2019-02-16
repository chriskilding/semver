#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "get-prerelease 0.0.0-a should be a" {
    [[ $(semver get-prerelease "0.0.0-a") = "a" ]]
}

@test "get-prerelease 0.0.0-abc should be abc" {
    [[ $(semver get-prerelease "0.0.0-abc") = "abc" ]]
}

@test "get-prerelease 0.0.0-1 should be 1" {
    [[ $(semver get-prerelease "0.0.0-1") = "1" ]]
}

@test "get-prerelease 0.0.0-1.2.3 should be 1.2.3" {
    [[ $(semver get-prerelease "0.0.0-1.2.3") = "1.2.3" ]]
}

@test "get-prerelease 0.0.0-a-1 should be a-1" {
    [[ $(semver get-prerelease "0.0.0-a-1") = "a-1" ]]
}

@test "get-prerelease 0.0.0- should fail" {
    run semver get-prerelease "0.0.0-"
    [[ "$status" -eq 1 ]]
}

@test "get-prerelease '' should fail" {
    run semver get-prerelease ""
    [[ "$status" -eq 1 ]]
}

@test "get-prerelease should not tolerate whitespace" {
    run semver get-prerelease " 0.0.0 "
    [[ "$status" -eq 1 ]]
}