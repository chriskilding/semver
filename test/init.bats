#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test "init should return 0.0.0" {
    [[ $(semver init) = "0.0.0" ]]
}