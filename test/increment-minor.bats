#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "increment-minor 0.0.0 should be 0.1.0" {
    [[ $(semver increment-minor "0.0.0") = "0.1.0" ]]
}

@test "increment-minor 0.1.0 should be 0.2.0" {
    [[ $(semver increment-minor "0.1.0") = "0.2.0" ]]
}

@test "increment-minor 0.10.0 should be 0.11.0" {
    [[ $(semver increment-minor "0.10.0") = "0.11.0" ]]
}

@test "increment-minor 0.1.2 should be 0.2.0" {
    [[ $(semver increment-minor "0.1.2") = "0.2.0" ]]
}

@test "increment-minor 0.-1.0 should fail" {
    run semver increment-minor "0.-1.0"
    [[ "$status" -eq 1 ]]
}

@test "increment-minor 0..0 should fail" {
    run semver increment-minor "0..0"
    [[ "$status" -eq 1 ]]
}

@test "increment-minor 0.a.0 should fail" {
    run semver increment-minor "0.a.0"
    [[ "$status" -eq 1 ]]
}

@test "increment-minor '' should fail" {
    run semver increment-minor ""
    [[ "$status" -eq 1 ]]
}

@test "increment-minor should not tolerate whitespace" {
    run semver increment-minor " 0.0.0 "
    [[ "$status" -eq 1 ]]
}