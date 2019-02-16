#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "increment-major 0.0.0 should be 1.0.0" {
    [[ $(semver increment-major "0.0.0") = "1.0.0" ]]
}

@test "increment-major 1.0.0 should be 2.0.0" {
    [[ $(semver increment-major "1.0.0") = "2.0.0" ]]
}

@test "increment-major 10.0.0 should be 11.0.0" {
    [[ $(semver increment-major "10.0.0") = "11.0.0" ]]
}

@test "increment-major 1.2.3 should be 2.0.0" {
    [[ $(semver increment-major "1.2.3") = "2.0.0" ]]
}

@test "increment-major -1.0.0 should fail" {
    run semver increment-major "-1.0.0"
    [[ "$status" -eq 1 ]]
}

@test "increment-major .0.0 should fail" {
    run semver increment-major ".0.0"
    [[ "$status" -eq 1 ]]
}

@test "increment-major a.0.0 should fail" {
    run semver increment-major "a.0.0"
    [[ "$status" -eq 1 ]]
}

@test "increment-major '' should fail" {
    run semver increment-major ""
    [[ "$status" -eq 1 ]]
}

@test "increment-major should not tolerate whitespace" {
    run semver increment-major " 0.0.0 "
    [[ "$status" -eq 1 ]]
}