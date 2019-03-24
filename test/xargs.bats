#!/usr/bin/env bats

semver() {
    ./semver "$@"
}

@test 'xargs: false should exit immediately' {
    run semver xargs false
    [[ "$status" -eq 1 ]] && [[ "$output" = "" ]]
}

