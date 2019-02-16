#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "decrement-major 1.0.0 should be 0.0.0" {
    [[ $(semver decrement-major "1.0.0") = "0.0.0" ]]
}

@test "decrement-major 2.0.0 should be 1.0.0" {
    [[ $(semver decrement-major "2.0.0") = "1.0.0" ]]
}

@test "decrement-major 11.0.0 should be 10.0.0" {
    [[ $(semver decrement-major "11.0.0") = "10.0.0" ]]
}

@test "decrement-major 2.0.0-alpha should be 1.0.0" {
    [[ $(semver decrement-major "2.0.0-alpha") = "1.0.0" ]]
}

@test "decrement-major 1.1.1 should be 0.0.0" {
    [[ $(semver decrement-major "1.1.1") = "0.0.0" ]]
}

@test "decrement-major 0.0.0 should fail" {
    run semver decrement-major "0.0.0"
    [[ "$status" -eq 1 ]]
}

@test "decrement-major '' should fail" {
    run semver decrement-major ""
    [[ "$status" -eq 1 ]]
}

@test "decrement-major -1.0.0 should fail" {
    run semver decrement-major "-1.0.0"
    [[ "$status" -eq 1 ]]
}

@test "decrement-major .0.0 should fail" {
    run semver decrement-major ".0.0"
    [[ "$status" -eq 1 ]]
}

@test "decrement-major a.0.0 should fail" {
    run semver decrement-major "0.a.0"
    [[ "$status" -eq 1 ]]
}

@test "decrement-major should not tolerate whitespace" {
    run semver decrement-major " 1.0.0 "
    [[ "$status" -eq 1 ]]
}