#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "semver -q: should exit 0 when there is a match" {
    run semver -q <<< '1.0.0'
    [[ -z "$output" ]] && [[ "$status" -eq 0 ]]
}

@test "semver -q: should exit 1 when no matches" {
    run semver -q <<< 'abc'
    [[ -z "$output" ]] && [[ "$status" -eq 1 ]]
}

@test 'semver -q: should alias to --quiet' {
    run semver --quiet <<< '1.0.0'
    [[ -z "$output" ]] && [[ "$status" -eq 0 ]]
}