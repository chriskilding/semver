#!/usr/bin/env bats

semver-increment() {
    ./semver-increment "$@"
}

@test "semver-increment --major: 0.0.0 should be 1.0.0" {
    [[ $(semver-increment --major "0.0.0") = "1.0.0" ]]
}

@test "semver-increment --minor: 0.0.0 should be 0.1.0" {
    [[ $(semver-increment --minor "0.0.0") = "0.1.0" ]]
}

@test "semver-increment --patch: 0.0.0 should be 0.0.1" {
    [[ $(semver-increment --patch "0.0.0") = "0.0.1" ]]
}

@test "semver-increment --major: 1.0.0 should be 2.0.0" {
    [[ $(semver-increment --major "1.0.0") = "2.0.0" ]]
}

@test "semver-increment --minor: 0.1.0 should be 0.2.0" {
    [[ $(semver-increment --minor "0.1.0") = "0.2.0" ]]
}

@test "semver-increment --patch: 0.0.1 should be 0.0.2" {
    [[ $(semver-increment --patch "0.0.1") = "0.0.2" ]]
}

@test "semver-increment --major: 10.0.0 should be 11.0.0" {
    [[ $(semver-increment --major "10.0.0") = "11.0.0" ]]
}

@test "semver-increment --minor: 0.10.0 should be 0.11.0" {
    [[ $(semver-increment --minor "0.10.0") = "0.11.0" ]]
}

@test "semver-increment --patch: 0.0.10 should be 0.0.11" {
    [[ $(semver-increment --patch "0.0.10") = "0.0.11" ]]
}

@test "semver-increment --major: 1.2.3 should be 2.0.0" {
    [[ $(semver-increment --major "1.2.3") = "2.0.0" ]]
}

@test "semver-increment --minor: 1.2.3 should be 1.3.0" {
    [[ $(semver-increment --minor "1.2.3") = "1.3.0" ]]
}

@test "semver-increment --patch: 1.2.3 should be 1.2.4" {
    [[ $(semver-increment --patch "1.2.3") = "1.2.4" ]]
}

@test "semver-increment --major: -1.0.0 should fail" {
    run semver-increment --major "-1.0.0"
    [[ "$status" -eq 1 ]]
}

@test "semver-increment --minor: 0.-1.0 should fail" {
    run semver-increment --minor "0.-1.0"
    [[ "$status" -eq 1 ]]
}

@test "semver-increment --patch: 0.0.-1 should fail" {
    run semver-increment --patch "0.0.-1"
    [[ "$status" -eq 1 ]]
}

@test "semver-increment: invalid version should fail" {
    run semver-increment --major ".0.0"
    [[ "$status" -eq 1 ]]
}

@test "semver-increment: '' should fail" {
    run semver-increment --major ""
    [[ "$status" -eq 1 ]]
}

@test "semver-increment: should not tolerate whitespace" {
    run semver-increment --major " 0.0.0 "
    [[ "$status" -eq 1 ]]
}

@test "semver-increment: -h should print usage" {
    run semver-increment -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}