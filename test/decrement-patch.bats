#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "decrement-patch 0.0.1 should be 0.0.0" {
    [[ $(semver decrement-patch "0.0.1") = "0.0.0" ]]
}

@test "decrement-patch 0.0.2 should be 0.0.1" {
    [[ $(semver decrement-patch "0.0.2") = "0.0.1" ]]
}

@test "decrement-patch 0.0.11 should be 0.0.10" {
    [[ $(semver decrement-patch "0.0.11") = "0.0.10" ]]
}

@test "decrement-patch 0.0.2-alpha should be 0.0.1" {
    [[ $(semver decrement-patch "0.0.2-alpha") = "0.0.1" ]]
}

@test "decrement-patch 0.0.0 should fail" {
    run semver decrement-patch "0.0.0"
    [[ "$status" -eq 1 ]]
}

@test "decrement-patch '' should fail" {
    run semver decrement-patch ""
    [[ "$status" -eq 1 ]]
}

@test "decrement-patch 0.0.-1 should fail" {
    run semver decrement-patch "0.0.-1"
    [[ "$status" -eq 1 ]]
}

@test "decrement-patch 0.0. should fail" {
    run semver decrement-patch "0.0."
    [[ "$status" -eq 1 ]]
}

@test "decrement-patch 0.0.a should fail" {
    run semver decrement-patch "0.0.a"
    [[ "$status" -eq 1 ]]
}

@test "decrement-patch should not tolerate whitespace" {
    run semver decrement-patch " 0.0.1 "
    [[ "$status" -eq 1 ]]
}