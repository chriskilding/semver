#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "help: -h should print usage" {
    run semver -h
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Version parser." ]]
}

@test "help: --help should print usage" {
    run semver --help
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Version parser." ]]
}

@test "help: invoking semver without arguments should print usage" {
    run semver
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Version parser." ]]
}

@test "help: invalid subcommand should print usage" {
    run semver foo
    [[ "$status" -eq 1 ]] && [[ "${lines[0]}" = "Semantic Version parser." ]]
}