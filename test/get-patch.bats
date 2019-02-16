#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "get-patch 0.0.0 should be 0" {
    [[ $(semver get-patch "0.0.0") = "0" ]]
}

@test "get-patch 0.0.1 should be 1" {
    [[ $(semver get-patch "0.0.1") = "1" ]]
}

@test "get-patch 0.0.10 should be 10" {
    [[ $(semver get-patch "0.0.10") = "10" ]]
}

@test "get-patch 0.0.-1 should fail" {
    run semver get-patch "0.0.-1"
    [[ "$status" -eq 1 ]]
}

@test "get-patch 0.0.01 should fail" {
    run semver get-patch "0.0.01"
    [[ "$status" -eq 1 ]]
}

@test "get-patch 0.0.a should fail" {
    run semver get-patch "0.0.a"
    [[ "$status" -eq 1 ]]
}

@test "get-patch '' should fail" {
    run semver get-patch ""
    [[ "$status" -eq 1 ]]
}

@test "get-patch should not tolerate whitespace" {
    run semver get-patch " 0.0.0 "
    [[ "$status" -eq 1 ]]
}