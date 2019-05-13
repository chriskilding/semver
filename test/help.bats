#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "help: -h should print usage" {
    run semver -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}

@test "help: --help should print usage" {
    run semver --help
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}