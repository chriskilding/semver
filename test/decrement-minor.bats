#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "decrement-minor 0.1.0 should be 0.0.0" {
    [[ $(semver decrement-minor "0.1.0") = "0.0.0" ]]
}

@test "decrement-minor 0.2.0 should be 0.1.0" {
    [[ $(semver decrement-minor "0.2.0") = "0.1.0" ]]
}

@test "decrement-minor 0.11.0 should be 0.10.0" {
    [[ $(semver decrement-minor "0.11.0") = "0.10.0" ]]
}

@test "decrement-minor 0.2.0-alpha should be 0.1.0" {
    [[ $(semver decrement-minor "0.2.0-alpha") = "0.1.0" ]]
}

@test "decrement-minor 0.1.1 should be 0.0.0" {
    [[ $(semver decrement-minor "0.1.1") = "0.0.0" ]]
}

@test "decrement-minor 0.0.0 should fail" {
    run semver decrement-minor "0.0.0"
    [[ "$status" -eq 1 ]]
}

@test "decrement-minor '' should fail" {
    run semver decrement-minor ""
    [[ "$status" -eq 1 ]]
}

@test "decrement-minor 0.-1.0 should fail" {
    run semver decrement-minor "0.-1.0"
    [[ "$status" -eq 1 ]]
}

@test "decrement-minor 0..0 should fail" {
    run semver decrement-minor "0..0"
    [[ "$status" -eq 1 ]]
}

@test "decrement-minor 0.a.0 should fail" {
    run semver decrement-minor "0.a.0"
    [[ "$status" -eq 1 ]]
}

@test "decrement-minor should not tolerate whitespace" {
    run semver decrement-minor " 0.1.0 "
    [[ "$status" -eq 1 ]]
}