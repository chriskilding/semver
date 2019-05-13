#!/usr/bin/env bats

semver-init() {
    ./semver-init "$@"
}

@test "semver-init: should return 0.0.0" {
    [[ $(semver-init) = "0.0.0" ]]
}

@test "semver-init: -h should print usage" {
    run semver-init -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}