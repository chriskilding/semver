#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "increment-patch 0.0.0 should be 0.0.1" {
    [[ $(semver increment-patch "0.0.0") = "0.0.1" ]]
}

@test "increment-patch 0.0.1 should be 0.0.2" {
    [[ $(semver increment-patch "0.0.1") = "0.0.2" ]]
}

@test "increment-patch 0.0.10 should be 0.0.11" {
    [[ $(semver increment-patch "0.0.10") = "0.0.11" ]]
}

@test "increment-patch 0.0.-1 should fail" {
    run semver increment-patch "0.0.-1"
    [[ "$status" -eq 1 ]]
}

@test "increment-patch 0.0. should fail" {
    run semver increment-patch "0.0."
    [[ "$status" -eq 1 ]]
}

@test "increment-patch 0.0.a should fail" {
    run semver increment-patch "0.0.a"
    [[ "$status" -eq 1 ]]
}

@test "increment-patch '' should fail" {
    run semver increment-patch ""
    [[ "$status" -eq 1 ]]
}

@test "increment-patch should not tolerate whitespace" {
    run semver increment-patch " 0.0.0 "
    [[ "$status" -eq 1 ]]
}