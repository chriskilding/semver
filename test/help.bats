#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "help: -h should print usage" {
    run semver -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}

@test "help: invalid subcommand should print usage" {
    run semver foo
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Versioning utility." ]]
}

@test "help: invalid option should print usage" {
    run semver -a <<< '1.0.0'
    [[ "$status" -eq 1 ]]
}