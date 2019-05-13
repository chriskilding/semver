#!/usr/bin/env bats

semver-decrement() {
    ./semver-decrement "$@"
}

@test "semver-decrement --major: 1.0.0 should be 0.0.0" {
    [[ $(semver-decrement --major "1.0.0") = "0.0.0" ]]
}

@test "semver-decrement --minor: 0.1.0 should be 0.0.0" {
    [[ $(semver-decrement --minor "0.1.0") = "0.0.0" ]]
}

@test "semver-decrement --patch: 0.0.1 should be 0.0.0" {
    [[ $(semver-decrement --patch "0.0.1") = "0.0.0" ]]
}

@test "semver-decrement --major: 2.0.0 should be 1.0.0" {
    [[ $(semver-decrement --major "2.0.0") = "1.0.0" ]]
}

@test "semver-decrement --minor: 0.2.0 should be 0.1.0" {
    [[ $(semver-decrement --minor "0.2.0") = "0.1.0" ]]
}

@test "semver-decrement --patch: 0.0.2 should be 0.0.1" {
    [[ $(semver-decrement --patch "0.0.2") = "0.0.1" ]]
}

@test "semver-decrement --major: 11.0.0 should be 10.0.0" {
    [[ $(semver-decrement --major "11.0.0") = "10.0.0" ]]
}

@test "semver-decrement --minor: 0.11.0 should be 0.10.0" {
    [[ $(semver-decrement --minor "0.11.0") = "0.10.0" ]]
}

@test "semver-decrement --patch: 0.0.11 should be 0.0.10" {
    [[ $(semver-decrement --patch "0.0.11") = "0.0.10" ]]
}

@test "semver-decrement --major: 2.0.0-alpha should be 1.0.0" {
    [[ $(semver-decrement --major "2.0.0-alpha") = "1.0.0" ]]
}

@test "semver-decrement --minor: 0.2.0-alpha should be 0.1.0" {
    [[ $(semver-decrement --minor "0.2.0-alpha") = "0.1.0" ]]
}

@test "semver-decrement --patch: 0.0.2-alpha should be 0.0.1" {
    [[ $(semver-decrement --patch "0.0.2-alpha") = "0.0.1" ]]
}

@test "semver-decrement --major: 1.1.1 should be 0.0.0" {
    [[ $(semver-decrement --major "1.1.1") = "0.0.0" ]]
}

@test "semver-decrement --minor: 0.1.1 should be 0.0.0" {
    [[ $(semver-decrement --minor "0.1.1") = "0.0.0" ]]
}

@test "semver-decrement --major: 0.0.0 should fail" {
    run semver-decrement --major "0.0.0"
    [[ "$status" -eq 1 ]]
}

@test "semver-decrement --minor: 0.0.0 should fail" {
    run semver-decrement --minor "0.0.0"
    [[ "$status" -eq 1 ]]
}

@test "semver-decrement --patch: 0.0.0 should fail" {
    run semver-decrement --patch "0.0.0"
    [[ "$status" -eq 1 ]]
}

@test "semver-decrement --major: -1.0.0 should fail" {
    run semver-decrement --major "-1.0.0"
    [[ "$status" -eq 1 ]]
}

@test "semver-decrement --minor: 0.-1.0 should fail" {
    run semver-decrement --minor "0.-1.0"
    [[ "$status" -eq 1 ]]
}

@test "semver-decrement --patch: 0.0.-1 should fail" {
    run semver-decrement --patch "0.0.-1"
    [[ "$status" -eq 1 ]]
}

@test "semver-decrement: '' should fail" {
    run semver-decrement --major ""
    [[ "$status" -eq 1 ]]
}

@test "semver-decrement: should not tolerate whitespace" {
    run semver-decrement --major " 1.0.0 "
    [[ "$status" -eq 1 ]]
}

@test "semver-decrement: invalid version should fail" {
    run semver-decrement --major "a.0.0"
    [[ "$status" -eq 1 ]]
}

@test "semver-decrement: -h should print usage" {
    run semver-decrement -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}