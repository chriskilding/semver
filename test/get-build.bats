#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "get-build 0.0.0+a should be a" {
    [[ $(semver get-build "0.0.0+a") = "a" ]]
}

@test "get-build 0.0.0+abc should be abc" {
    [[ $(semver get-build "0.0.0+abc") = "abc" ]]
}

@test "get-build 0.0.0+1 should be 1" {
    [[ $(semver get-build "0.0.0+1") = "1" ]]
}

@test "get-build 0.0.0+1.2.3 should be 1.2.3" {
    [[ $(semver get-build "0.0.0+1.2.3") = "1.2.3" ]]
}

@test "get-build 0.0.0+ should fail" {
    run semver get-build "0.0.0+"
    [[ "$status" -eq 1 ]]
}

@test "get-build '' should fail" {
    run semver get-build ""
    [[ "$status" -eq 1 ]]
}

@test "get-build should not tolerate whitespace" {
    run semver get-build " 0.0.0 "
    [[ "$status" -eq 1 ]]
}