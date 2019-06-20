#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "semver -h: should print usage" {
    run semver -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}

@test "semver -h: should alias to --help" {
    run semver --help
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}